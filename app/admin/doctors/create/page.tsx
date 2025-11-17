import { DoctorForm } from "@/components/doctor-form"

export default function CreateDoctorPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Add Doctor</h1>
        <p className="text-slate-600 mt-2">Add a new doctor profile</p>
      </div>

      <DoctorForm />
    </div>
  )
}
