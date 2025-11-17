import { createClient } from "@/lib/supabase/server"
import { DoctorForm } from "@/components/doctor-form"
import { notFound } from "next/navigation"

export default async function EditDoctorPage({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  const supabase = await createClient()

  const { data: doctor, error } = await supabase.from("doctors").select("*").eq("id", id).single()

  if (error || !doctor) {
    notFound()
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Edit Doctor</h1>
        <p className="text-slate-600 mt-2">Update doctor profile information</p>
      </div>

      <DoctorForm doctor={doctor} />
    </div>
  )
}
