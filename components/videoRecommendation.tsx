"use client";

import { fetchYouTubeVideos, YouTubeVideo } from "@/lib/utils";
import { useEffect, useState } from "react";

interface props {
  search_query: string;
  fallback_title: string;
}
const videoRecommendation = ({ search_query, fallback_title }: props) => {
  const [video, setVideo] = useState<YouTubeVideo | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  async function fetchVideo() {
    setIsLoading(true);
    try {
      const response = await fetchYouTubeVideos(search_query);
      setVideo(response);
    } catch (error) {
      console.error("Error fetching video:", error);
    } finally {
      setIsLoading(false);
    }
  }

  useEffect(() => {
    let isMounted = true;
    if (isMounted) {
      fetchVideo();
    }
    return () => {
      isMounted = false;
    };
  }, [search_query]);

  if (isLoading) {
    return (
      <div className="w-full h-48 bg-gray-200 animate-pulse rounded-lg flex items-center justify-center">
        <span className="text-gray-400">Loading Video...</span>
      </div>
    );
  }

  if (!video) {
    // Fallback if API fails or quota exceeded
    return (
      <div className="w-full p-4 border rounded-lg bg-gray-50 text-center">
        <p className="text-sm text-gray-500">
          Video unavailable for: {fallback_title}
        </p>
        <a
          href={`https://www.youtube.com/results?search_query=${encodeURIComponent(
            search_query
          )}`}
          target="_blank"
          className="text-indigo-600 hover:underline text-xs mt-2 block"
        >
          Search on YouTube
        </a>
      </div>
    );
  }

  return (
    <div className="w-full">
      {/* The Embed Player */}
      <div className="relative w-full aspect-video rounded-lg overflow-hidden shadow-sm border bg-black">
        <iframe
          width="100%"
          height="100%"
          src={`https://www.youtube.com/embed/${video.videoId}`}
          title={video.title}
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowFullScreen
          className="absolute inset-0"
        />
      </div>

      <p className="mt-2 text-sm font-medium text-gray-800 line-clamp-2">
        {video.title}
      </p>
    </div>
  );
};

export default videoRecommendation;
