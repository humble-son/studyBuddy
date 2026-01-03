"use client";

import { useState } from "react";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Sparkles, Loader2 } from "lucide-react";

interface InputZoneProps {
  onSolve: (question: string) => void;
  isLoading: boolean;
  handleSetQuestion: (question: string) => void;
}

export function InputZone({
  onSolve,
  isLoading,
  handleSetQuestion,
}: InputZoneProps) {
  const [question, setQuestion] = useState("");

  const handleSubmit = () => {
    if (question.trim()) {
      handleSetQuestion(question);
      onSolve(question);
    }
  };

  return (
    <div className="max-w-4xl mx-auto">
      <div className="text-center mb-8">
        <h1 className="text-4xl lg:text-5xl font-bold text-foreground mb-3 text-balance">
          Your AI Learning Companion
        </h1>
        <p className="text-lg text-muted-foreground text-balance">
          Paste your homework question and get step-by-step solutions with
          explanations
        </p>
      </div>

      <Card className="shadow-lg border-border">
        <CardContent className="p-6">
          <Textarea
            placeholder="Paste your homework question here..."
            className="min-h-[200px] text-base resize-none"
            value={question}
            onChange={(e) => setQuestion(e.target.value)}
            disabled={isLoading}
          />
          <div className="mt-4 flex justify-end">
            <Button
              size="lg"
              onClick={handleSubmit}
              disabled={isLoading || !question.trim()}
              className="gap-2"
            >
              {isLoading ? (
                <>
                  <Loader2 className="size-4 animate-spin" />
                  Thinking...
                </>
              ) : (
                <>
                  <Sparkles className="size-4" />
                  Solve & Explain
                </>
              )}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
