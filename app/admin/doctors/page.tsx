import { createClient } from "@/lib/supabase/server"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Plus, Pencil, Mail, Phone } from "lucide-react"
import Link from "next/link"
import { DeleteDoctorButton } from "@/components/delete-doctor-button"
import Image from "next/image"

export default async function DoctorsPage() {
  const supabase = await createClient()

  const { data: doctors, error } = await supabase.from("doctors").select("*").order("created_at", { ascending: false })

  if (error) {
    console.error("Error fetching doctors:", error)
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-slate-900">Doctors Management</h1>
          <p className="text-slate-600 mt-2">Manage medical staff and doctor profiles</p>
        </div>
        <Button asChild>
          <Link href="/admin/doctors/create">
            <Plus className="h-4 w-4 mr-2" />
            Add Doctor
          </Link>
        </Button>
      </div>

      {!doctors || doctors.length === 0 ? (
        <Card className="border-slate-200">
          <CardContent className="text-center py-12">
            <p className="text-slate-600">No doctors found.</p>
            <Button asChild className="mt-4">
              <Link href="/admin/doctors/create">Add your first doctor</Link>
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {doctors.map((doctor) => (
            <Card key={doctor.id} className="border-slate-200">
              <CardHeader className="pb-3">
                <div className="flex items-start gap-4">
                  <div className="relative h-16 w-16 rounded-full overflow-hidden bg-slate-100">
                    <Image
                      src={doctor.image_url || "/placeholder.svg?height=64&width=64"}
                      alt={doctor.full_name}
                      fill
                      className="object-cover"
                    />
                  </div>
                  <div className="flex-1 min-w-0">
                    <CardTitle className="text-lg truncate">{doctor.full_name}</CardTitle>
                    <p className="text-sm text-slate-600 truncate">{doctor.specialization}</p>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="space-y-3">
                <div className="text-sm space-y-2">
                  <div className="flex items-center gap-2 text-slate-600">
                    <span className="font-medium">Experience:</span>
                    <span>{doctor.experience_years} years</span>
                  </div>
                  {doctor.email && (
                    <div className="flex items-center gap-2 text-slate-600 truncate">
                      <Mail className="h-3 w-3 flex-shrink-0" />
                      <span className="truncate text-xs">{doctor.email}</span>
                    </div>
                  )}
                  {doctor.phone && (
                    <div className="flex items-center gap-2 text-slate-600">
                      <Phone className="h-3 w-3 flex-shrink-0" />
                      <span className="text-xs">{doctor.phone}</span>
                    </div>
                  )}
                </div>

                <div>
                  <Badge
                    variant={
                      doctor.status === "active" ? "default" : doctor.status === "on_leave" ? "secondary" : "outline"
                    }
                  >
                    {doctor.status.replace("_", " ")}
                  </Badge>
                </div>

                <div className="flex gap-2 pt-2">
                  <Button variant="outline" size="sm" asChild className="flex-1 bg-transparent">
                    <Link href={`/admin/doctors/edit/${doctor.id}`}>
                      <Pencil className="h-3 w-3 mr-1" />
                      Edit
                    </Link>
                  </Button>
                  <DeleteDoctorButton id={doctor.id} name={doctor.full_name} />
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
