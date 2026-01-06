import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";
import apiClient from "./auth";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export interface YouTubeVideo {
  videoId: string;
  title: string;
  thumbnailUrl: string;
}

const YOUTUBE_API_KEY = process.env.NEXT_PUBLIC_YOUTUBE_API;
const YOUTUBE_API_URL = process.env.NEXT_PUBLIC_YOUTUBE_SEARCH_URL;

export async function fetchYouTubeVideos(
  searchTerm: string
): Promise<YouTubeVideo | null> {
  try {
    const { data } = await apiClient.get(YOUTUBE_API_URL!, {
      params: {
        part: "snippet",
        q: searchTerm,
        type: "video",
        maxResults: 1,
        key: YOUTUBE_API_KEY,
      },
    });

    if (data.items && data.items.length > 0) {
      const video = data.items[0];

      return {
        videoId: video.id.videoId,
        title: video.snippet.title,
        thumbnailUrl: video.snippet.thumbnails.high.url,
      };
    }

    return null;
  } catch (error) {
    console.error("Error fetching YouTube videos:", error);
    return null;
  }
}
