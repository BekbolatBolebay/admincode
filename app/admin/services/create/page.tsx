import { ServiceForm } from "@/components/service-form"

export default function CreateServicePage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Create Service</h1>
        <p className="text-slate-600 mt-2">Add a new medical service</p>
      </div>

      <ServiceForm />
    </div>
  )
}
