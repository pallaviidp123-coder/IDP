import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { Lock, Mail, ArrowRight, AlertCircle, Droplets } from 'lucide-react';
import { motion } from 'motion/react';

export const AdminLogin: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    console.debug('[Login] Attempting sign-in for:', email);
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (!error && data?.user) {
        console.debug('[Login] Success! Session established for:', data.user?.email);
        localStorage.setItem('idp_admin_is_bypass', 'false');
        navigate('/admin-dashboard');
        return;
      }

      console.warn('[Login] Supabase Auth signInWithPassword error, checking local fallback:', error?.message);
    } catch (catchErr: any) {
      console.warn('[Login] Supabase Auth threw exception:', catchErr);
    }

    // Emergency developer fallback for standard preview/testing (unlocks the UI instantly)
    if (email.trim() === 'admin@idp.gov.in' && password === 'admin123') {
      console.log('[Login] Development credentials accepted. Establishing local simulated session.');
      const simulatedSession = {
        access_token: 'local-bypass-token',
        user: {
          id: 'local-admin-uuid',
          email: 'admin@idp.gov.in',
          role: 'authenticated',
          aud: 'authenticated',
          created_at: new Date().toISOString()
        }
      };
      localStorage.setItem('idp_admin_session', JSON.stringify(simulatedSession));
      localStorage.setItem('idp_admin_is_bypass', 'true');
      
      // Let standard UI know that login succeeded
      window.dispatchEvent(new Event('storage'));
      
      navigate('/admin-dashboard');
    } else {
      setError('Invalid admin credentials. Use the authorized system account, or use preview credentials: admin@idp.gov.in / admin123');
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#020617] flex items-center justify-center p-4 relative overflow-hidden">
      {/* Animated Background Elements */}
      <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-blue-600/10 blur-[120px] rounded-full animate-pulse" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-cyan-600/10 blur-[120px] rounded-full animate-pulse" />

      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md"
      >
        <div className="bg-slate-900/50 backdrop-blur-xl border border-white/10 p-8 rounded-3xl shadow-2xl">
          <div className="flex flex-col items-center mb-8">
            <div className="w-16 h-16 bg-blue-600 rounded-2xl flex items-center justify-center mb-4 shadow-lg shadow-blue-600/20">
              <Droplets className="text-white" size={32} />
            </div>
            <h1 className="text-2xl font-black text-white tracking-tight">Admin Portal</h1>
            <p className="text-slate-400 text-sm mt-1">India Drought Pulse Monitoring</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-6">
            {error && (
              <motion.div 
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                className="bg-red-500/10 border border-red-500/20 p-4 rounded-xl flex items-center gap-3 text-red-400 text-sm"
              >
                <AlertCircle size={18} />
                {error}
              </motion.div>
            )}

            <div className="space-y-2">
              <label className="text-xs font-bold uppercase tracking-widest text-slate-500 ml-1">Email Address</label>
              <div className="relative">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500" size={18} />
                <input
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full bg-slate-800/50 border border-slate-700 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 rounded-xl py-3 pl-12 pr-4 text-white placeholder:text-slate-600 transition-all outline-none"
                  placeholder="admin@idp.gov.in"
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-bold uppercase tracking-widest text-slate-500 ml-1">Password</label>
              <div className="relative">
                <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500" size={18} />
                <input
                  type="password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full bg-slate-800/50 border border-slate-700 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 rounded-xl py-3 pl-12 pr-4 text-white placeholder:text-slate-600 transition-all outline-none"
                  placeholder="••••••••"
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-blue-600 hover:bg-blue-500 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-600/20 flex items-center justify-center gap-2 transition-all group"
            >
              {loading ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  Access Terminal
                  <ArrowRight size={18} className="group-hover:translate-x-1 transition-transform" />
                </>
              )}
            </button>
          </form>

          <div className="mt-8 pt-8 border-t border-white/5 flex justify-center">
            <Link to="/" className="text-slate-500 hover:text-white text-sm font-medium transition-colors">
              Return to Public Dashboard
            </Link>
          </div>
        </div>
      </motion.div>
    </div>
  );
};
