"use client";

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Lightbulb, Play } from "lucide-react";
import { Answer } from "@/app/page";
import Latex from "react-latex-next";

export function ContextSidebar({ answer }: { answer: Answer }) {
  return (
    <div className="space-y-6 lg:sticky lg:top-6">
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Related Topics</CardTitle>
          <CardDescription>Explore connected concepts</CardDescription>
        </CardHeader>
        <CardContent className="flex flex-wrap gap-2">
          {answer.related_topics.map(
            (topic, id) =>
              topic.length < 50 && (
                <Badge key={id} className="text-xs">
                  #{topic}
                </Badge>
              )
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <Lightbulb className="size-4 text-accent" />
            Why This Matters
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground leading-relaxed">
            <Latex>
              {answer.real_world_applications[0].replaceAll("**", "")}
            </Latex>
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
