"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { SolutionContent } from "@/components/solution-content";
import { PracticeQuestions } from "@/components/practice-questions";
import { ContextSidebar } from "@/components/context-sidebar";
import { Skeleton } from "@/components/ui/skeleton";

interface SolutionDashboardProps {
  isLoading: boolean;
  answer: any;
  question: string;
}

export function SolutionDashboard({
  isLoading,
  answer,
  question,
}: SolutionDashboardProps) {
  if (isLoading) {
    return (
      <div className="grid lg:grid-cols-[300px_1fr] gap-6">
        <div className="space-y-4">
          <Skeleton className="h-[200px] w-full" />
          <Skeleton className="h-[300px] w-full" />
        </div>
        <div className="space-y-4">
          <Skeleton className="h-[400px] w-full" />
        </div>
      </div>
    );
  }

  return (
    <div className="grid lg:grid-cols-[300px_1fr] gap-6">
      {/* Left Sidebar - Context & Navigation */}
      <aside className="order-2 lg:order-1">
        <ContextSidebar answer={answer} />
      </aside>

      {/* Right Main Content - Solution & Practice */}
      <main className="order-1 lg:order-2">
        <Tabs defaultValue="solution" className="w-full">
          <TabsList className="grid w-full grid-cols-2 mb-6">
            <TabsTrigger value="solution">Solution</TabsTrigger>
            <TabsTrigger value="practice">Practice More</TabsTrigger>
          </TabsList>
          <TabsContent value="solution" className="mt-0">
            <SolutionContent answer={answer} question={question} />
          </TabsContent>
          <TabsContent value="practice" className="mt-0">
            <PracticeQuestions answer={answer} />
          </TabsContent>
        </Tabs>
      </main>
    </div>
  );
}
