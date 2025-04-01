import SwiftUI

struct AppointmentView: View {
    // MARK: - Properties
    weak var delegate: AppointmentsHostingController?

    @State private var selectedDate: Date = .init()
    @State private var showingAllAppointments = false
    var appointments: [Appointment]

    // Date formatter for displaying dates
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()

    // MARK: - Computed Properties
    private var displayedAppointments: [Appointment] {
        if showingAllAppointments {
            return appointments.sorted { $0.startDate < $1.startDate }
        } else {
            return appointments.filter { appointment in
                Calendar.current.isDate(appointment.startDate, inSameDayAs: selectedDate)
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Calendar View
                DatePicker("Select Date",
                          selection: $selectedDate,
                          displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onChange(of: selectedDate) { _ in
                        if showingAllAppointments {
                            showingAllAppointments = false
                        }
                    }

                // Selected Date Header
                HStack {
                    Text(showingAllAppointments ? "All Appointments" : "Appointments")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Spacer()

                    Button(action: {
                        showingAllAppointments.toggle()
                    }) {
                        Text(showingAllAppointments ? "Filter by Date" : "See All")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 4)

                // Appointments List
                LazyVStack(spacing: 12) {
                    if displayedAppointments.isEmpty {
                        noAppointmentsView
                    } else {
                        ForEach(displayedAppointments) { appointment in
                            AppointmentCard(appointment: appointment, delegate: delegate)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    // MARK: - Supporting Views
    private var noAppointmentsView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(Color(.systemGray3))
                .padding(.bottom, 8)

            Text("No Appointments Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(showingAllAppointments
                 ? "You don't have any appointments scheduled." : "You don't have any appointments scheduled for \(dateFormatter.string(from: selectedDate)). Select a different date to view other appointments.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if !showingAllAppointments {
                Button(action: {
                    selectedDate = Date()
                }) {
                    Text("Go to Today")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {

    // MARK: Internal

    let status: AppointmentStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(statusColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.12))
            .clipShape(Capsule())
    }

    // MARK: Private

    private var statusColor: Color {
        switch status {
        case .confirmed: return .green
        case .cancelled: return .red
        default: return .gray
        }
    }
}
