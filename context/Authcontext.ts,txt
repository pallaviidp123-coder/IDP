import React, { createContext, useContext, useEffect, useState } from 'react';
import { User, Session } from '@supabase/supabase-js';
import { supabase } from '../lib/supabase';

interface AuthContextType {
  user: User | null;
  session: Session | null;
  loading: boolean;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);

    // 1. Initial check - check localStorage fallback first, then Supabase session
    const localSessionStr = localStorage.getItem('idp_admin_session');
    if (localSessionStr) {
      try {
        const parsed = JSON.parse(localSessionStr);
        if (parsed && parsed.user) {
          setSession(parsed);
          setUser(parsed.user);
          setLoading(false);
          console.log("[Auth] Persistent session restored from localStorage:", parsed.user.email);
        }
      } catch (e) {
        console.warn("Could not parse local session", e);
      }
    }

    supabase.auth.getSession().then(({ data: { session: sbSession } }) => {
      if (sbSession) {
        setSession(sbSession);
        setUser(sbSession.user ?? null);
        localStorage.setItem('idp_admin_session', JSON.stringify(sbSession));
      } else if (!localStorage.getItem('idp_admin_session')) {
        setSession(null);
        setUser(null);
      }
      setLoading(false);
    }).catch(err => {
      console.warn("Supabase getSession rejected:", err);
      setLoading(false);
    });

    // 2. Listen for changes on auth state (logged in, signed out, etc.)
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, sbSession) => {
      if (sbSession) {
        setSession(sbSession);
        setUser(sbSession.user ?? null);
        localStorage.setItem('idp_admin_session', JSON.stringify(sbSession));
      } else {
        // If there's no supabase session and we don't have a local bypass, clean up
        const isBypass = localStorage.getItem('idp_admin_is_bypass') === 'true';
        if (!isBypass) {
          setSession(null);
          setUser(null);
          localStorage.removeItem('idp_admin_session');
        }
      }
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signOut = async () => {
    localStorage.removeItem('idp_admin_session');
    localStorage.removeItem('idp_admin_is_bypass');
    try {
      await supabase.auth.signOut();
    } catch (e) {
      console.warn("Supabase signOut error, handling locally:", e);
    }
    setSession(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, session, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
