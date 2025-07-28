defmodule FranmalthPortfolioWeb.HomeLive do
  use FranmalthPortfolioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       active_tab: "home",
       tabs: ["home", "work", "projects", "contact"]
     )}
  end

  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen w-screen flex flex-col items-center justify-center bg-[#1a1b26] text-[#c0caf5] font-mono px-4 py-6 md:px-8">
      <!-- Stickers & Time -->
      <div class="absolute top-6 left-6">
        <img src="/images/black-star.png" class="w-12 h-12" />
      </div>
      <div class="absolute top-6 right-6 text-sm">
        <%= Timex.format!(Timex.now(), "%H:%M", :strftime) %>
      </div>

      <!-- Main Panel -->
      <div class="bg-[#1e1e2e] w-full max-w-5xl min-h-[420px] rounded-2xl p-12 shadow-xl border border-[#2a2e3f]">
        <div class="flex justify-between items-center mb-6">
          <div class="text-sm text-[#7dcfff]"><%= @active_tab %></div>
        </div>

        <h1 class="text-5xl font-bold mb-2">
          Hey <span class="text-[#7aa2f7]">I'm</span> <span class="text-[#bb9af7]">Ryugel | Franmalth</span>
        </h1>
        <p class="text-base mb-8 text-[#c0caf5]">software engineer</p>

        <!-- Tabs -->
        <div class="flex space-x-6 mb-6">
          <%= for tab <- @tabs do %>
            <button phx-click="switch_tab" phx-value-tab={tab}
              class={"px-6 py-2 text-sm rounded-lg transition-all duration-200 #{if @active_tab == tab, do: "bg-[#7aa2f7] text-black", else: "hover:bg-[#3b4261]"}"}>
              <%= tab %>
            </button>
          <% end %>
        </div>

        <!-- Tab Content -->
        <div class="mt-2 text-lg space-y-4">
          <%= case @active_tab do %>
            <% "home" -> %>
              <p>Welcome to my portfolio. Feel free to explore!</p>

            <% "work" -> %>
              <div>
                <p class="text-xl font-semibold text-[#bb9af7]">Software Engineer – BNP Paribas</p>
                <p class="text-sm text-[#c0caf5]">2023–2025</p>
              </div>
              <div>
                <p class="text-xl font-semibold text-[#bb9af7]">Business Analyst – CACIB</p>
                <p class="text-sm text-[#c0caf5]">2025–2026</p>
              </div>

            <% "projects" -> %>
              <ul class="list-disc pl-6 space-y-1">
                <li><strong>Pulseboard</strong>: Real-time product analytics dashboard (Elixir & Phoenix LiveView)</li>
                <li><strong>Baran</strong>: iOS app for browsing & discovering movies (Swift, TMDB API)</li>
                <li><strong>PharmaX</strong>: Data analysis project on French prescription data</li>
              </ul>

            <% "contact" -> %>
              <p>📬 Contact me at: <span class="text-[#7aa2f7]">franmalth@example.com</span></p>
          <% end %>
        </div>
      </div>

      <!-- Floating Terminal (only if not on home) -->
      <%= if @active_tab != "home" do %>
        <div id="floating-terminal" phx-hook="Draggable"
             class="z-50 bg-[#1e1e2e] border border-[#7aa2f7] text-[#c0caf5] w-[90vw] max-w-2xl p-6 rounded-xl shadow-2xl font-mono text-sm fixed"
             style="top: 120px; left: 120px;">
          <div class="flex justify-between items-center mb-4 cursor-move">
            <span class="text-[#7aa2f7]">~$ <%= @active_tab %></span>
            <button phx-click="switch_tab" phx-value-tab="home"
              class="text-red-400 hover:text-red-600 text-xs">[x]</button>
          </div>

          <pre><%= terminal_content(@active_tab) %></pre>
        </div>
      <% end %>

      <div class="absolute bottom-4 right-6">
        <img src="/images/black-star.png" class="w-14 h-14" />
      </div>
    </div>
    """
  end

  # Terminal output
  defp terminal_content("work"), do: """
  whoami
  # Software Engineer @ BNP Paribas
  # Business Analyst @ CACIB
  """

  defp terminal_content("projects"), do: """
  ls ~/projects
  - Pulseboard
  - Baran
  - PharmaX
  """

  defp terminal_content("contact"), do: """
  echo " franmath@example.com"
  """

  defp terminal_content("home"), do: ""
end
