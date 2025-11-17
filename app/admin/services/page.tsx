import { createClient } from "@/lib/supabase/server"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Plus, Pencil } from "lucide-react"
import Link from "next/link"
import { DeleteServiceButton } from "@/components/delete-service-button"

export default async function ServicesPage() {
  const supabase = await createClient()

  const { data: services, error } = await supabase
    .from("services")
    .select("*")
    .order("created_at", { ascending: false })

  if (error) {
    console.error("Error fetching services:", error)
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-slate-900">Services Management</h1>
          <p className="text-slate-600 mt-2">Manage medical services and offerings</p>
        </div>
        <Button asChild>
          <Link href="/admin/services/create">
            <Plus className="h-4 w-4 mr-2" />
            Add Service
          </Link>
        </Button>
      </div>

      <Card className="border-slate-200">
        <CardHeader>
          <CardTitle>All Services</CardTitle>
        </CardHeader>
        <CardContent>
          {!services || services.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-slate-600">No services found.</p>
              <Button asChild className="mt-4">
                <Link href="/admin/services/create">Create your first service</Link>
              </Button>
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Name</TableHead>
                  <TableHead>Category</TableHead>
                  <TableHead>Features</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {services.map((service) => (
                  <TableRow key={service.id}>
                    <TableCell className="font-medium">{service.name}</TableCell>
                    <TableCell>{service.category}</TableCell>
                    <TableCell>
                      <span className="text-sm text-slate-600">{service.features?.length || 0} features</span>
                    </TableCell>
                    <TableCell>
                      <Badge variant={service.status === "active" ? "default" : "secondary"}>{service.status}</Badge>
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button variant="outline" size="sm" asChild>
                          <Link href={`/admin/services/edit/${service.id}`}>
                            <Pencil className="h-4 w-4" />
                          </Link>
                        </Button>
                        <DeleteServiceButton id={service.id} name={service.name} />
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
