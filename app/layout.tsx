import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Next.js ECS Terraform',
  description: 'Next.js deployed on AWS ECS with Terraform',
  metadataBase: new URL('https://localhost:3000'),
  openGraph: {
    title: 'Next.js ECS Terraform',
    description: 'Next.js deployed on AWS ECS with Terraform',
    type: 'website',
  },
  robots: {
    index: true,
    follow: true,
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className="antialiased">{children}</body>
    </html>
  )
} 