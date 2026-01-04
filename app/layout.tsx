import type React from "react";
import type { Metadata } from "next";
import "./globals.css";
import { Sparkles } from "lucide-react";
import Link from "next/link";

export const metadata: Metadata = {
  title: "StudyBuddy AI - Your Intelligent Homework Assistant",
  description:
    "Get step-by-step solutions and explanations for your homework questions with AI-powered learning",
  generator: "v0.app",
  icons: {
    icon: [
      {
        url: "/icon-light-32x32.png",
        media: "(prefers-color-scheme: light)",
      },
      {
        url: "/icon-dark-32x32.png",
        media: "(prefers-color-scheme: dark)",
      },
      {
        url: "/icon.svg",
        type: "image/svg+xml",
      },
    ],
    apple: "/apple-icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`font-sans antialiased min-h-screen flex flex-col`}>
        <header className="border-b border-border bg-card">
          <div className="container mx-auto px-4 py-4 flex items-center justify-between">
            <Link href={"/"} className="flex items-center gap-2">
              <div className="size-8 rounded-lg bg-primary flex items-center justify-center">
                <Sparkles className="size-4 text-primary-foreground" />
              </div>
              <span className="font-semibold text-lg text-foreground">
                StudyBuddy AI
              </span>
            </Link>
            <nav className="flex items-center gap-6">
              <Link
                href="/dashboard"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Dashboard
              </Link>
              <Link
                href="/history"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                History
              </Link>
            </nav>
          </div>
        </header>
        {children}
        <footer>
          <div className="text-sm text-muted-foreground flex justify-center items-center border-t border-border text-white bg-blue-800 h-24">
            <p>
              &copy; {new Date().getFullYear()} StudyBuddy AI. All rights
              reserved.
            </p>
          </div>
        </footer>
        {/* <Analytics /> */}
      </body>
    </html>
  );
}
