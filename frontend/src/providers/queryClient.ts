import { QueryClient } from '@tanstack/react-query';

// Centralized QueryClient with sensible supervisory application defaults
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes (supervisory analytics data)
      gcTime: 1000 * 60 * 30,    // 30 minutes garbage collection time
      retry: 1,                  // Retry failed queries once before showing ErrorState
      refetchOnWindowFocus: false, // Prevent aggressive window focus refetching
      refetchOnReconnect: true,
    },
    mutations: {
      retry: 0,                  // Do not automatically retry failed mutations
    },
  },
});

export default queryClient;
