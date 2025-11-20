import { createClient } from "@/lib/supabase/server"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Plus, Pencil } from "lucide-react"
import Link from "next/link"
import { DeleteNewsButton } from "@/components/delete-news-button"

export default async function NewsPage() {
  const supabase = await createClient()

  const { data: news, error } = await supabase.from("news").select("*").order("created_at", { ascending: false })

  if (error) {
    console.error("Error fetching news:", error)
    if (error.code === "PGRST205") {
      return (
        <div className="p-6 bg-red-50 border border-red-200 rounded-lg">
          <h3 className="text-lg font-semibold text-red-800">Database Setup Required</h3>
          <p className="text-red-600 mt-2">
            The news table was not found. Please run the SQL scripts in the "Scripts" section to set up your database.
          </p>
        </div>
      )
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-slate-900">News Management</h1>
          <p className="text-slate-600 mt-2">Manage news articles and updates</p>
        </div>
        <Button asChild>
          <Link href="/admin/news/create">
            <Plus className="h-4 w-4 mr-2" />
            Add News
          </Link>
        </Button>
      </div>

      <Card className="border-slate-200">
        <CardHeader>
          <CardTitle>All News Articles</CardTitle>
        </CardHeader>
        <CardContent>
          {!news || news.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-slate-600">No news articles found.</p>
              <Button asChild className="mt-4">
                <Link href="/admin/news/create">Create your first article</Link>
              </Button>
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Title</TableHead>
                  <TableHead>Category</TableHead>
                  <TableHead>Author</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Published Date</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {news.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell className="font-medium">{item.title}</TableCell>
                    <TableCell>{item.category}</TableCell>
                    <TableCell>{item.author}</TableCell>
                    <TableCell>
                      <Badge
                        variant={
                          item.status === "published" ? "default" : item.status === "draft" ? "secondary" : "outline"
                        }
                      >
                        {item.status}
                      </Badge>
                    </TableCell>
                    <TableCell>{new Date(item.published_date).toLocaleDateString()}</TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button variant="outline" size="sm" asChild>
                          <Link href={`/admin/news/edit/${item.id}`}>
                            <Pencil className="h-4 w-4" />
                          </Link>
                        </Button>
                        <DeleteNewsButton id={item.id} title={item.title} />
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
