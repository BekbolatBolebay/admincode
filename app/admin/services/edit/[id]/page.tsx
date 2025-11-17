import { createClient } from "@/lib/supabase/server"
import { ServiceForm } from "@/components/service-form"
import { notFound } from "next/navigation"

export default async function EditServicePage({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  const supabase = await createClient()

  const { data: service, error } = await supabase.from("services").select("*").eq("id", id).single()

  if (error || !service) {
    notFound()
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Edit Service</h1>
        <p className="text-slate-600 mt-2">Update service information</p>
      </div>

      <ServiceForm service={service} />
    </div>
  )
}
