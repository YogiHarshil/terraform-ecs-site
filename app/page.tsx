'use client';

import React, { useState, useEffect, useCallback } from 'react';

interface DeploymentInfo {
  status: string;
  timestamp: string;
  environment: string;
  version: string;
  uptime: number;
  service: string;
}

export default function Home() {
  const [info, setInfo] = useState<DeploymentInfo | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchHealthData = useCallback(async () => {
    try {
      setError(null);
      const response = await fetch('/api/health');
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      setInfo(data);
    } catch (err) {
      console.error('Failed to fetch health data:', err);
      setError('Unable to load deployment info');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchHealthData();
  }, [fetchHealthData]);

  const formatUptime = (seconds: number): string => {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${hours}h ${minutes}m`;
  };

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 text-white p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold text-center mb-8">
          🚀 Next.js on AWS ECS
        </h1>
        
        <div className="grid gap-6 md:grid-cols-2">
          <div className="bg-white/10 backdrop-blur-md rounded-xl p-6">
            <h2 className="text-xl font-semibold mb-4">Deployment Status</h2>
            {loading ? (
              <div className="animate-pulse">
                <div className="h-4 bg-white/20 rounded mb-2"></div>
                <div className="h-4 bg-white/20 rounded mb-2"></div>
                <div className="h-4 bg-white/20 rounded"></div>
              </div>
            ) : error ? (
              <div className="text-red-200">
                <p>{error}</p>
                <button 
                  onClick={fetchHealthData}
                  className="mt-2 px-4 py-2 bg-white/20 rounded hover:bg-white/30 transition-colors"
                >
                  Retry
                </button>
              </div>
            ) : info ? (
              <div className="space-y-2">
                <p><strong>Status:</strong> 
                  <span className={`ml-2 px-2 py-1 rounded text-xs ${
                    info.status === 'healthy' ? 'bg-green-500' : 'bg-yellow-500'
                  }`}>
                    {info.status}
                  </span>
                </p>
                <p><strong>Environment:</strong> {info.environment}</p>
                <p><strong>Version:</strong> {info.version}</p>
                <p><strong>Uptime:</strong> {formatUptime(info.uptime)}</p>
                <p><strong>Last Updated:</strong> {new Date(info.timestamp).toLocaleString()}</p>
              </div>
            ) : null}
          </div>

          <div className="bg-white/10 backdrop-blur-md rounded-xl p-6">
            <h2 className="text-xl font-semibold mb-4">Architecture</h2>
            <ul className="space-y-2">
              <li>🐳 Containerized with Docker</li>
              <li>☁️ AWS ECS Fargate</li>
              <li>🏗️ Terraform Infrastructure</li>
              <li>🔄 GitHub Actions CI/CD</li>
              <li>📊 CloudWatch Monitoring</li>
            </ul>
          </div>
        </div>
      </div>
    </main>
  );
} 