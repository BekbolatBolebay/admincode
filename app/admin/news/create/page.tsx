import { NewsForm } from "@/components/news-form"

export default function CreateNewsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Create News Article</h1>
        <p className="text-slate-600 mt-2">Add a new news article or update</p>
      </div>

      <NewsForm />
    </div>
  )
}
