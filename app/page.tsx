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
import { Button } from "@/components/ui/button";
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
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  function handleSetQuestion(question: string) {
    setQuestion(question);
  }

  const getErrorText = (error: any) => {
    const status = error?.response?.status;
    const backendMessage =
      error?.response?.data?.message ||
      error?.response?.data?.error ||
      error?.message ||
      "Something went wrong while solving your question.";

    if (status === 404) {
      return "The solver service could not be found. Please try again in a moment.";
    }

    if (status === 500) {
      return "The solver service is currently unavailable. Please try again in a moment.";
    }

    if (status === 429) {
      return "Too many requests. Please wait a moment and try again.";
    }

    return `${backendMessage}`;
  };

  const handleSolve = async (question: string) => {
    setIsLoading(true);
    setAnswer(null);
    setErrorMessage(null);

    try {
      const { data } = await apiClient.post("/solve-question", { question });
      setAnswer(data.data);
    } catch (error: any) {
      console.error("Error solving question:", error);
      setErrorMessage(getErrorText(error));
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

      {hasSubmitted && errorMessage && (
        <div className="mt-8 max-w-4xl mx-auto">
          <div className="rounded-lg border border-destructive/50 bg-destructive/10 p-4 text-sm text-destructive">
            <p className="font-medium">Unable to solve this question</p>
            <p className="mt-1">{errorMessage}</p>
            <Button
              variant="outline"
              size="sm"
              className="mt-3"
              onClick={() => handleSolve(question)}
              disabled={isLoading}
            >
              Try again
            </Button>
          </div>
        </div>
      )}

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
                {answer.video_search_queries.map((video, id: number) => {
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
