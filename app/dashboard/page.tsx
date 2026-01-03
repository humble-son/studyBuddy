import { Button } from "@/components/ui/button";
import { Home } from "lucide-react";
import Link from "next/link";

const page = () => {
  return (
    <div className="flex flex-1 justify-center items-center text-gray-500 flex-col space-y-4">
      <p>Coming Soon</p>
      <Button asChild className="ml-4">
        <Link href="/">
          {" "}
          <Home className="w-4 h-4" />
          Back to Home
        </Link>
      </Button>
    </div>
  );
};

export default page;
