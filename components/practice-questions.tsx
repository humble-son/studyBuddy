"use client";

import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Answer } from "@/app/page";
import Latex from "react-latex-next";

export function PracticeQuestions({ answer }: { answer: Answer }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Practice More</CardTitle>
        <CardDescription>
          Test your understanding with similar problems
        </CardDescription>
      </CardHeader>
      <CardContent>
        <Accordion type="multiple" className="w-full">
          {answer.practice_questions.map((q, index) => (
            <AccordionItem key={index} value={`question-${index + 1}`}>
              <AccordionTrigger className="text-left hover:no-underline">
                <div className="flex items-start gap-3 w-full pr-4 break-words">
                  <span className="flex-shrink-0 size-6 rounded-full bg-primary text-primary-foreground text-xs flex items-center justify-center font-semibold">
                    {index + 1}
                  </span>
                  <div className="flex-1 w-64 overflow-x-auto max-w-full">
                    <p className="text-sm font-medium text-foreground whitespace-pre-wrap">
                      <Latex>{q.question.replaceAll("**", "")}</Latex>
                    </p>
                  </div>
                </div>
              </AccordionTrigger>
              <AccordionContent>
                <div className="ml-9 p-4 rounded-lg overflow-x-auto max-w-full whitespace-pre-wrap">
                  {q.answer.steps.map((step, stepIndex) => (
                    <div key={stepIndex} className="">
                      <p className=" p-4 my-2 bg-secondary rounded-lg text-secondary-foreground text-sm leading-relaxed whitespace-pre-wrap">
                        <Latex>{step.replaceAll("**", "")}</Latex>
                      </p>
                    </div>
                  ))}
                </div>

                <div className="mt-4 p-4 bg-accent border border-accent rounded-lg break-all overflow-x-auto max-w-full">
                  <p className="font-semibold text-accent-foreground mb-2">
                    Final Answer:
                  </p>
                  <p className="text-sm text-accent-foreground whitespace-pre-line leading-relaxed break-all whitespace-pre-wrap">
                    <Latex>{q.answer.final_answer}</Latex>
                  </p>
                </div>
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      </CardContent>
    </Card>
  );
}
