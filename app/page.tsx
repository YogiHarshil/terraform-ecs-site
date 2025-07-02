'use client';

import React, { useState, useEffect } from 'react';

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

  useEffect(() => {
    fetch('/api/health')
      .then(res => res.json())
      .then(data => {
        setInfo(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

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
              <div className="animate-pulse">Loading...</div>
            ) : info ? (
              <div className="space-y-2">
                <p><strong>Status:</strong> {info.status || 'Healthy'}</p>
                <p><strong>Environment:</strong> {info.environment}</p>
                <p><strong>Version:</strong> {info.version}</p>
                <p><strong>Uptime:</strong> {info.uptime}s</p>
                <p><strong>Last Updated:</strong> {new Date(info.timestamp).toLocaleString()}</p>
              </div>
            ) : (
              <p>Unable to load deployment info</p>
            )}
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