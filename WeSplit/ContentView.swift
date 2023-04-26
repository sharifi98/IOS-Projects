import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    @State private var splitEvenly = true
    @State private var unevenSplits: [Int] = Array(repeating: 1, count: 2)

    let tipPercentages = [10, 15, 20, 25, 0]

    // Color palette
    let mainColor = Color.blue
    let secondaryColor = Color.yellow

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)

        let tipValue = Double(checkAmount) ?? 0 / 100 * tipSelection
        let grandTotal = Double(checkAmount) ?? 0 + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }

    var grandTotal: Double {
        let tipValue = Double(checkAmount) ?? 0 / 100 * Double(tipPercentage)
        return Double(checkAmount) ?? 0 + tipValue
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Amount", text: $checkAmount)
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        Toggle("Split evenly", isOn: $splitEvenly)
                            .padding(.bottom, 20)
                            .toggleStyle(SwitchToggleStyle(tint: mainColor))

                        if splitEvenly {
                            Picker("Number of people", selection: $numberOfPeople) {
                                ForEach(2..<100) {
                                    Text("\($0) people")
                                }

                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        } else {
                            ForEach(0..<unevenSplits.count, id: \.self) { index in
                                Stepper("Person \(index + 1): \(unevenSplits[index])", value: $unevenSplits[index], in: 1...10)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                            Button(action: {
                                withAnimation {
                                    unevenSplits.append(1)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(mainColor)
                                    Text("Add person")
                                }
                            }
                            .padding(.top, 10)
                        }
                    }

                    Section(header: Text("How much tip do you want to leave?")
                                .font(.headline)
                                .foregroundColor(mainColor)) {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(0..<101) {
                                Text($0, format: .percent)
                            }

                        }
                        .pickerStyle(.navigationLink)
                    }
                    Section(header: Text("Amount per person")
                        .font(.headline)
                        .foregroundColor(mainColor)) {
                if splitEvenly {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.title2)
                        .foregroundColor(secondaryColor)
                } else {
                    ForEach(0..<unevenSplits.count, id: \.self) { index in
                        Text("Person \(index + 1): \(unevenSplits[index], specifier: "%.2f") NOK")
                            .font(.title2)
                            .foregroundColor(secondaryColor)
                    }
                }
            }

            Section(header: Text("Grand total")
                        .font(.headline)
                        .foregroundColor(mainColor)) {
                Text(grandTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.title2)
                    .foregroundColor(secondaryColor)
            }
        }
        .navigationTitle("WeSplit")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    amountIsFocused = false
                }
            }
        }
    }
    .background(Color(.systemGroupedBackground))
    .edgesIgnoringSafeArea(.bottom)
}
}
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
ContentView()
}
}

