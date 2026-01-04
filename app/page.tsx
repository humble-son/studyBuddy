"use client";

import { useState } from "react";
import { InputZone } from "@/components/input-zone";
import { SolutionDashboard } from "@/components/solution-dashboard";
import apiClient from "@/lib/auth";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import VideoRecommendation from "@/components/videoRecommendation";

export interface Answer {
  main_solution: { steps: string[]; final_answer: string };
  practice_questions: {
    question: string;
    answer: { steps: string[]; final_answer: string };
  }[];
  real_world_applications: string[];
  related_topics: string[];
  video_search_queries: { title: string; search_term: string }[];
}

export default function Page() {
  const [isLoading, setIsLoading] = useState(false);
  const [hasSubmitted, setHasSubmitted] = useState(false);
  const [question, setQuestion] = useState<string>("");
  const [answer, setAnswer] = useState<Answer | null>(null);

  function handleSetQuestion(question: string) {
    setQuestion(question);
  }

  const handleSolve = async (question: string) => {
    setIsLoading(true);
    setAnswer(null);
    try {
      const { data } = await apiClient.post("/solve-question", { question });
      setAnswer(data.data);

      // Handle the response as needed
    } catch (error) {
      console.error("Error solving question:", error);
    } finally {
      setIsLoading(false);
      setHasSubmitted(true);
    }
  };

  return (
    <main className="bg-background container mx-auto px-4 py-8 lg:py-12 flex-1">
      <InputZone
        onSolve={handleSolve}
        isLoading={isLoading}
        handleSetQuestion={handleSetQuestion}
      />
      {hasSubmitted && answer && (
        <div className="mt-12">
          <SolutionDashboard
            isLoading={isLoading}
            answer={answer}
            question={question}
          />
          {!isLoading && (
            <Card className="mt-6">
              <CardHeader>
                <CardTitle className="text-base">Video Resources</CardTitle>
                <CardDescription>
                  Learn with visual explanations
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4 gap-4 grid md:grid-cols-2 lg:grid-cols-5">
                {answer.video_search_queries.map((video, id) => {
                  return (
                    <VideoRecommendation
                      key={id}
                      search_query={video.search_term}
                      fallback_title={video.search_term}
                    />
                  );
                })}
              </CardContent>
            </Card>
          )}
        </div>
      )}
    </main>
  );
}
