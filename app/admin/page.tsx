import { createClient } from "@/lib/supabase/server"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Newspaper, Briefcase, Users, TrendingUp, Clock, FileText } from "lucide-react"
import Link from "next/link"
import { Badge } from "@/components/ui/badge"

export default async function AdminDashboardPage() {
  const supabase = await createClient()

  const [newsResult, servicesResult, doctorsResult, recentNews] = await Promise.all([
    supabase.from("news").select("*", { count: "exact", head: true }),
    supabase.from("services").select("*", { count: "exact", head: true }),
    supabase.from("doctors").select("*", { count: "exact", head: true }),
    supabase.from("news").select("*").order("created_at", { ascending: false }).limit(5),
  ])

  const { count: publishedNewsCount } = await supabase
    .from("news")
    .select("*", { count: "exact", head: true })
    .eq("status", "published")

  const { count: activeServicesCount } = await supabase
    .from("services")
    .select("*", { count: "exact", head: true })
    .eq("status", "active")

  const { count: activeDoctorsCount } = await supabase
    .from("doctors")
    .select("*", { count: "exact", head: true })
    .eq("status", "active")

  const stats = [
    {
      title: "Total News",
      value: newsResult.count || 0,
      subtitle: `${publishedNewsCount || 0} published`,
      icon: Newspaper,
      description: "Published articles",
      color: "bg-blue-500",
      href: "/admin/news",
    },
    {
      title: "Total Services",
      value: servicesResult.count || 0,
      subtitle: `${activeServicesCount || 0} active`,
      icon: Briefcase,
      description: "Active services",
      color: "bg-green-500",
      href: "/admin/services",
    },
    {
      title: "Total Doctors",
      value: doctorsResult.count || 0,
      subtitle: `${activeDoctorsCount || 0} active`,
      icon: Users,
      description: "Medical staff",
      color: "bg-purple-500",
      href: "/admin/doctors",
    },
    {
      title: "Engagement",
      value: "95%",
      subtitle: "Last 30 days",
      icon: TrendingUp,
      description: "Overall performance",
      color: "bg-orange-500",
      href: "/admin",
    },
  ]

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900">Dashboard Overview</h1>
        <p className="text-slate-600 mt-2">Monitor your medical website content and performance</p>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        {stats.map((stat) => (
          <Link key={stat.title} href={stat.href}>
            <Card className="border-slate-200 hover:border-slate-300 transition-colors cursor-pointer">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-slate-600">{stat.title}</CardTitle>
                <div className={`${stat.color} p-2 rounded-lg`}>
                  <stat.icon className="h-4 w-4 text-white" />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-3xl font-bold text-slate-900">{stat.value}</div>
                <p className="text-xs text-slate-500 mt-1">{stat.subtitle}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        {/* Recent News Activity */}
        <Card className="border-slate-200">
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Clock className="h-5 w-5 text-slate-600" />
                Recent News Activity
              </CardTitle>
              <Link href="/admin/news" className="text-sm text-blue-600 hover:text-blue-700">
                View all
              </Link>
            </div>
          </CardHeader>
          <CardContent>
            {!recentNews.data || recentNews.data.length === 0 ? (
              <div className="text-center py-8 text-slate-600">
                <FileText className="h-12 w-12 mx-auto mb-3 text-slate-400" />
                <p>No recent news articles</p>
              </div>
            ) : (
              <div className="space-y-4">
                {recentNews.data.map((news) => (
                  <div
                    key={news.id}
                    className="flex items-start gap-3 p-3 rounded-lg hover:bg-slate-50 transition-colors"
                  >
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <h4 className="font-medium text-slate-900 truncate">{news.title}</h4>
                        <Badge variant={news.status === "published" ? "default" : "secondary"} className="text-xs">
                          {news.status}
                        </Badge>
                      </div>
                      <p className="text-xs text-slate-600">
                        {news.category} • {news.author}
                      </p>
                      <p className="text-xs text-slate-500 mt-1">
                        {new Date(news.created_at).toLocaleDateString("en-US", {
                          month: "short",
                          day: "numeric",
                          year: "numeric",
                        })}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <Card className="border-slate-200">
          <CardHeader>
            <CardTitle>Quick Actions</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              <Link
                href="/admin/news/create"
                className="flex items-center gap-3 p-4 rounded-lg border border-slate-200 hover:border-blue-300 hover:bg-blue-50 transition-colors"
              >
                <div className="bg-blue-100 p-2 rounded-lg">
                  <Newspaper className="h-5 w-5 text-blue-600" />
                </div>
                <div>
                  <p className="font-medium text-slate-900">Create News Article</p>
                  <p className="text-sm text-slate-600">Publish a new article</p>
                </div>
              </Link>

              <Link
                href="/admin/services/create"
                className="flex items-center gap-3 p-4 rounded-lg border border-slate-200 hover:border-green-300 hover:bg-green-50 transition-colors"
              >
                <div className="bg-green-100 p-2 rounded-lg">
                  <Briefcase className="h-5 w-5 text-green-600" />
                </div>
                <div>
                  <p className="font-medium text-slate-900">Add New Service</p>
                  <p className="text-sm text-slate-600">Create service listing</p>
                </div>
              </Link>

              <Link
                href="/admin/doctors/create"
                className="flex items-center gap-3 p-4 rounded-lg border border-slate-200 hover:border-purple-300 hover:bg-purple-50 transition-colors"
              >
                <div className="bg-purple-100 p-2 rounded-lg">
                  <Users className="h-5 w-5 text-purple-600" />
                </div>
                <div>
                  <p className="font-medium text-slate-900">Add Doctor Profile</p>
                  <p className="text-sm text-slate-600">Create staff profile</p>
                </div>
              </Link>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Content Overview */}
      <Card className="border-slate-200">
        <CardHeader>
          <CardTitle>Content Status Overview</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-3">
            <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
              <div className="flex items-center justify-between mb-2">
                <h4 className="text-sm font-medium text-blue-900">News Articles</h4>
                <Newspaper className="h-4 w-4 text-blue-600" />
              </div>
              <p className="text-2xl font-bold text-blue-900">{newsResult.count || 0}</p>
              <p className="text-xs text-blue-700 mt-1">
                {publishedNewsCount || 0} published, {(newsResult.count || 0) - (publishedNewsCount || 0)} drafts
              </p>
            </div>

            <div className="p-4 bg-green-50 rounded-lg border border-green-200">
              <div className="flex items-center justify-between mb-2">
                <h4 className="text-sm font-medium text-green-900">Services</h4>
                <Briefcase className="h-4 w-4 text-green-600" />
              </div>
              <p className="text-2xl font-bold text-green-900">{servicesResult.count || 0}</p>
              <p className="text-xs text-green-700 mt-1">
                {activeServicesCount || 0} active, {(servicesResult.count || 0) - (activeServicesCount || 0)} inactive
              </p>
            </div>

            <div className="p-4 bg-purple-50 rounded-lg border border-purple-200">
              <div className="flex items-center justify-between mb-2">
                <h4 className="text-sm font-medium text-purple-900">Doctors</h4>
                <Users className="h-4 w-4 text-purple-600" />
              </div>
              <p className="text-2xl font-bold text-purple-900">{doctorsResult.count || 0}</p>
              <p className="text-xs text-purple-700 mt-1">
                {activeDoctorsCount || 0} active, {(doctorsResult.count || 0) - (activeDoctorsCount || 0)} inactive
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
