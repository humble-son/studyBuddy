"use client";
import Latex from "react-latex-next";

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Copy, Check } from "lucide-react";
import { useState } from "react";
import { Answer } from "@/app/page";

export function SolutionContent({
  answer,
  question,
}: {
  answer: Answer;
  question: string;
}) {
  const [copied, setCopied] = useState(false);

  const solutionText =
    answer.main_solution.steps.join("\n") +
    "\nFinal Answer: " +
    answer.main_solution.final_answer;

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(solutionText);
      setCopied(true);
      setTimeout(() => setCopied(false), 3000);
    } catch (error) {
      console.error("Failed to copy text: ", error);
    }
  };

  return (
    <Card>
      <CardHeader>
        <div className="flex items-start justify-between">
          <div>
            <CardTitle>Step-by-Step Solution</CardTitle>
            <CardDescription>
              Detailed explanation of the problem
            </CardDescription>
          </div>
          <Button
            variant="outline"
            size="sm"
            onClick={handleCopy}
            className="gap-2 bg-transparent"
          >
            {copied ? (
              <>
                <Check className="size-4" />
                Copied
              </>
            ) : (
              <>
                <Copy className="size-4" />
                Copy
              </>
            )}
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        <div className="prose prose-sm max-w-none">
          <h3 className="text-lg font-semibold text-foreground mt-0">
            Question:
          </h3>
          <p className="text-foreground">
            <Latex>{question}</Latex>
          </p>

          <h3 className="text-lg font-semibold text-foreground mt-6">
            Solution:
          </h3>

          <div className="space-y-4">
            {answer.main_solution.steps.map((elem: any, index: number) => {
              return (
                <p
                  key={index}
                  className=" p-4 bg-secondary rounded-lg text-secondary-foreground text-sm leading-relaxed"
                >
                  <Latex>{elem.replaceAll("**", "")}</Latex>
                </p>
              );
            })}
          </div>

          <div className="mt-6 p-4 bg-accent border border-accent rounded-lg">
            <p className="font-semibold text-accent-foreground mb-2">
              Final Answer:
            </p>
            <p className="text-accent-foreground text-sm leading-relaxed">
              <Latex>{answer.main_solution.final_answer}</Latex>
            </p>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
