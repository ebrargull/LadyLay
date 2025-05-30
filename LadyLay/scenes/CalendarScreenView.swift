import SwiftUI

struct CalendarScreenView: View {
    @EnvironmentObject var theme: ThemeViewModel
    @Binding var isLoggedIn: Bool
    @State private var selectedDate: Date? = Date()
    @State private var displayedMonth: Date = Date()
    @State private var lastPeriodStart: Date = Date()
    @State private var cycleLength: Int = 28
    @State private var periodDuration: Int = 5

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Ay geçişi başlığı
                HStack {
                    Button {
                        displayedMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text(monthYearString(displayedMonth))
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.gray)

                    Spacer()

                    Button {
                        displayedMonth = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                // Gün başlıkları
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { day in
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.selectedColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 2)
                    }
                }

                // Gün hücreleri
                let calendar = Calendar.current
                let days = generateDays(for: displayedMonth)
                let (periodDates, ovulationDates) = generatePredictedPeriods(for: displayedMonth)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        if calendar.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                            Color.clear.frame(width: 45, height: 50)
                        } else {
                            let isPeriodDay = periodDates.contains(where: { calendar.isDate($0, inSameDayAs: date) })
                            let isOvulationDay = ovulationDates.contains(where: { calendar.isDate($0, inSameDayAs: date) })
                            let isSelected = calendar.isDate(date, inSameDayAs: selectedDate ?? Date())

                            let backgroundColor: Color = {
                                if isSelected {
                                    return theme.selectedColor
                                } else if isPeriodDay && isOvulationDay {
                                    return theme.selectedColor.opacity(0.7)
                                } else if isPeriodDay {
                                    return theme.selectedColor.opacity(0.5)
                                } else if isOvulationDay {
                                    return theme.selectedColor.opacity(0.3)
                                } else {
                                    return Color.white.opacity(0.5)
                                }
                            }()

                            Text("\(calendar.component(.day, from: date))")
                                .font(.body)
                                .frame(width: 42, height: 42)
                                .background(backgroundColor)
                                .clipShape(Circle())
                                .foregroundColor((isPeriodDay || isOvulationDay || isSelected) ? .white : .black)
                                .onTapGesture {
                                    selectedDate = date
                                }
                                .shadow(radius: isSelected ? 3 : 1)
                        }
                    }
                }
                .padding(.horizontal)

                Divider().padding(.vertical, 10)

                // Regl ve döngü ayarları
                VStack(alignment: .leading, spacing: 10) {
                    DatePicker("Son regl tarihi", selection: $lastPeriodStart, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .accentColor(theme.selectedColor)
                        .font(.body.bold())

                    Stepper("Döngü süresi: \(cycleLength) gün", value: $cycleLength, in: 20...40)
                        .foregroundColor(theme.selectedColor)
                        .font(.body.bold())

                    Stepper("Regl süresi: \(periodDuration) gün", value: $periodDuration, in: 1...10)
                        .foregroundColor(theme.selectedColor)
                        .font(.body.bold())

                    if let next = Calendar.current.date(byAdding: .day, value: cycleLength, to: lastPeriodStart) {
                        Text("Tahmini regl başlangıcı: \(formattedDate(next))🦩")
                            .foregroundColor(.pink)
                            .font(.body.bold())
                            .padding(.top, 2)
                    }
                }
                .padding(.horizontal)

                // Açıklayıcı renk legend'ı
                HStack(spacing: 20) {
                    legendLabel(color: theme.selectedColor.opacity(0.3), text: "Regl")
                    legendLabel(color: theme.selectedColor.opacity(0.15), text: "Yumurtlama")
                    legendLabel(color: theme.selectedColor.opacity(0.7), text: "Seçili Gün")
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.top)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, theme.selectedColor.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    // MARK: - Yardımcı Görünümler ve Fonksiyonlar

    func legendLabel(color: Color, text: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    func generatePredictedPeriods(for month: Date) -> ([Date], [Date]) {
        var periodDates: [Date] = []
        var ovulationDates: [Date] = []
        let calendar = Calendar.current

        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return ([], [])
        }

        let lastOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: firstOfMonth)!
        var currentStart = lastPeriodStart

        for _ in 0..<24 {
            let periodStart = currentStart
            let periodEnd = calendar.date(byAdding: .day, value: periodDuration - 1, to: periodStart)!

            if periodEnd >= firstOfMonth && periodStart <= lastOfMonth {
                for i in 0..<periodDuration {
                    if let d = calendar.date(byAdding: .day, value: i, to: periodStart),
                       d >= firstOfMonth, d <= lastOfMonth {
                        periodDates.append(d)
                    }
                }
            }

            if let ovulationStart = calendar.date(byAdding: .day, value: cycleLength - 14 - 5, to: currentStart) {
                for i in 0..<6 {
                    if let d = calendar.date(byAdding: .day, value: i, to: ovulationStart),
                       d >= firstOfMonth, d <= lastOfMonth {
                        ovulationDates.append(d)
                    }
                }
            }

            currentStart = calendar.date(byAdding: .day, value: cycleLength, to: currentStart)!
            if currentStart > lastOfMonth { break }
        }

        return (periodDates, ovulationDates)
    }

    func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date).capitalized
    }

    func generateDays(for month: Date) -> [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let firstWeekday = calendar.dateComponents([.weekday], from: firstOfMonth).weekday else {
            return []
        }

        let emptyDays = (firstWeekday + 5) % 7
        days.append(contentsOf: Array(repeating: Date.distantPast, count: emptyDays))

        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }

        return days
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}
