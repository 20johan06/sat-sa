/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Clean enterprise light/neutral application surfaces
        surface: {
          bg: '#F8FAFC',       // Slate 50 (Application background)
          card: '#FFFFFF',     // Pure White (Content surface)
          elevated: '#F1F5F9', // Slate 100 (Subtle container / elevated)
          hover: '#F8FAFC',    // Slate 50 (Hover background)
          subtle: '#E2E8F0',   // Slate 200
        },
        header: {
          bg: '#0F172A',       // Deep Navy / Slate 900 for authoritative header & navigation
          surface: '#1E293B',  // Slate 800 for active nav items
          border: '#334155',   // Slate 700 header border
        },
        border: {
          subdued: '#E2E8F0',  // Slate 200 border
          default: '#CBD5E1',  // Slate 300 border
          strong: '#94A3B8',   // Slate 400 border
          focus: '#2563EB',    // Blue 600 focus ring
        },
        content: {
          primary: '#0F172A',   // Slate 900 (Main readable dark text)
          secondary: '#475569', // Slate 600
          muted: '#64748B',     // Slate 500
          inverse: '#FFFFFF',   // Pure White
        },
        // Canonical Severity Tokens (Restrained, Enterprise Semantic Colors)
        severity: {
          critical: {
            bg: '#FEF2F2',
            border: '#FCA5A5',
            text: '#991B1B',
            badge: '#991B1B',
          },
          high: {
            bg: '#FFF7ED',
            border: '#FDBA74',
            text: '#9A3412',
            badge: '#9A3412',
          },
          medium: {
            bg: '#FEFCE8',
            border: '#FDE047',
            text: '#854D0E',
            badge: '#854D0E',
          },
          low: {
            bg: '#EFF6FF',
            border: '#93C5FD',
            text: '#1E40AF',
            badge: '#1E40AF',
          },
        },
        // Brand & Action Tokens
        brand: {
          50: '#EFF6FF',
          100: '#DBEAFE',
          500: '#3B82F6',
          600: '#2563EB',
          700: '#1D4ED8',
          900: '#1E3A8A',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
        mono: ['JetBrains Mono', 'Fira Code', 'ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'monospace'],
      },
    },
  },
  plugins: [],
}
