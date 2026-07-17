//
//  ContentView.swift
//  دليل  حفص
//
//  Created by Feysel on 15/07/2026.
//

import SwiftUI

// Navigation Route
enum AppRoute: Hashable {
    case about
    case book(Book)
}

// Book Model
struct Book: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let fileName: String
    let description: String
}

// Custom Colors
extension Color {
    static let brandTeal = Color(red: 0.0, green: 0.478, blue: 0.463)
    static let appBackground = Color(.systemBackground)
}

// Share Sheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Content View
struct ContentView: View {
    @State private var showMenu = false
    @State private var searchText = ""
    @State private var showShareSheet = false
    @State private var navigationPath = NavigationPath()

    let books: [Book] = [
        Book(title: "القرءان الكريم", fileName: "القرءان الكريم", description: "القرءان الكريم، مراحل نزول القرءان الكريم، أحرف القرءان الكريم، القرءان المكي والمدني، أهمية القرءان الكريم، صفات القرءان الكريم، فضل تلاوة القرءان الكريم..."),
        Book(title: "تدوين المصحف", fileName: "تدوين المصحف", description: "مراحل تدوين المصحف، خصائص مراحل التدوين، عدد المصاحف العثمانية، علاقة المصاحف العثمانية بالأحرف السبعة."),
        Book(title: "رسم المصحف", fileName: "رسم المصحف", description: "الرسم العثماني، أقسام الرسم، حكم تعلم الرسم العثماني، مذاهب العلماء في الرسم العثماني، فوائد الرسم العثماني..."),
        Book(title: "التجويد", fileName: "التجويد", description: "التجويد لغةً: التحسين، واصطلاحاً: عِلْمٌ بكيفية أداء كلمات القرآن الكريم من حيث إخراج كل حرف من مخرجه وإعطائه حقه ومستحقه."),
        Book(title: "المدود", fileName: "المدود", description: "أحكام المد، أنواع المد الأصلي والفرعي، مقدار حركات المدود وتطبيقاتها العملية في رواية حفص عن عاصم."),
        Book(title: "مخارج وألقاب الحروف", fileName: "مخارج وألقاب الحروف", description: "مخارج الحروف الخمسة الرئيسية، تفصيل مخارج الحروف السبعة عشر، وألقاب الحروف بحسب موضع خروجها."),
        Book(title: "صفات الحروف", fileName: "صفات الحروف", description: "الصفات التي لها ضد والصفات التي لا ضد لها، وبيان أثر الصفات القوية والضعيفة في نطق الحروف العربية سليمة."),
        Book(title: "الاستعاذة والبسملة", fileName: "الاستعاذة والبسملة", description: "أحكام الاستعاذة والبسملة عند البدء بالقراءة، وأوجه الاقتران بينهما وبين السور القرآنية المتتالية."),
        Book(title: "همزة القطع وهمزة الوصل", fileName: "همزة القطع وهمزة الوصل", description: "الفرق بين همزة الوصل والقطع في النطق والرسم، وحكم الابتداء بهمزات الوصل في الأسماء والأفعال والحروف."),
        Book(title: "ما يراعى لحفص", fileName: "ما يراعى لحفص", description: "الكلمات الفرشية المخصوصة التي يراعيها الإمام حفص عن عاصم من طريق الشاطبية في الأداء والوقف."),
        Book(title: "سلسلة السند", fileName: "سلسلة السند", description: "سند رواية حفص عن عاصم المتصلة بالنبي صلى الله عليه وسلم، وترجمة الرواة والعلماء الأجلاء في السلسلة."),
        Book(title: "النون الساكنة والتنوين", fileName: "النون الساكنة والتنوين", description: "أحكام النون الساكنة والتنوين الأربعة: الإظهار الحلقي، الإدغام، الإقلاب، والإخفاء الحقيقي مع الأمثلة."),
        Book(title: "القطع", fileName: "القطع", description: "مفهوم القطع والفرق بينه وبين السكت والوقف، وأحكامهما المتبعة أثناء تلاوة آيات الذكر الحكيم."),
        Book(title: "الحروف والأصوات", fileName: "الحروف والأصوات", description: "نشأة الأصوات اللغوية، مخارجها الفيزيائية، وتفاعل الحروف المتجاورة داخل الكلمات القرآنية."),
        Book(title: "القراء العشرة", fileName: "القراء العشرة", description: "تعريف بالقراء العشرة وأقسام القراءات المتواترة، مع إضاءات تاريخية حول أئمة هذا الفن العظيم."),
        Book(title: "المفيد في التجويد", fileName: "المفيد في التجويد", description: "متن منظومة المفيد في علم التجويد وشرح لأهم قواعدها الأساسية بأسلوب ميسر وشامل لمختلف الأبواب."),
        Book(title: "بهجة اللحاظ", fileName: "بهجة اللُّحَاظِ", description: "شرح منظومة بهجة اللحاظ في حكم لحن الألفاظ وتنبيه القارئ إلى الأخطاء الجلية والخفية الشائعة."),
        Book(title: "علاقة الحروف", fileName: "علاقة الحروف", description: "أحكام تماثل وتجانس وتقارب وتباعد الحروف، وتأثير هذه العلاقات على قواعد الإدغام والإظهار."),
        Book(title: "الميم الساكنة", fileName: "الميم الساكنة", description: "أحكام الميم الساكنة الثلاثة: الإخفاء الشفوي، الإدغام الشفوي (المثلين الصغير)، والإظهار الشفوي."),
        Book(title: "قصر المنفصل", fileName: "قصر المنفصل", description: "أحكام قصر المد المنفصل لحفص من طريق الطيبية وما يترتب عليه من قواعد أدائية خاصة."),
        Book(title: "رائية الخاقاني", fileName: "رائية الخاقاني", description: "قصيدة أبي مزاحم الخاقاني الأولى في علم التجويد وحسن أداء القراءة مع ضبط قواعد مخارج الحروف."),
        Book(title: "السلسبيل الشافي", fileName: "السلسبيل الشافي", description: "متن السلسبيل الشافي في علم التجويد للشيخ عثمان سليمان مراد، بشرح وافٍ وتطبيقات أدائية."),
        Book(title: "تاء وهاء التأنيث", fileName: "تاء وهاء التأنيث", description: "أحكام التاءات المفتوحة والمربوطة (هاء التأنيث) وكيفية الوقف عليها في المصحف الشريف."),
        Book(title: "اللحن وأقسامه", fileName: "اللحن وأقسامه", description: "بيان اللحن الجلي واللحن الخفي، وحكم كل منهما شرعاً وتأثيرهما على صحة الصلاة والتلاوة."),
        Book(title: "القراءات", fileName: "القراءات", description: "مدخل إلى علم القراءات القرآنية، بيان وجوه التواتر والشذوذ، وحكمة تعدد القراءات في الأمة الإسلامية."),
        Book(title: "الوقف", fileName: "الوقف", description: "تعريف الوقف وأقسامه الاختيارية والاضطرارية، والوقف القبيح والوقف التام والجهد الأدائي المطلوب."),
        Book(title: "التحفة السمنودية", fileName: "التحفة السمنودية", description: "شرح متن التحفة السمنودية في تجويد الكلمات القرآنية لعلامة العصر الشيخ إبراهيم السمنودي."),
        Book(title: "اللام الساكنة", fileName: "اللام الساكنة", description: "أحكام لامات الساكنة: لام ال التعريف، لام الفعل، لام الاسم، لام الحرف، ولام الأمر مع توضيح أحكامها."),
        Book(title: "التقاء الساكنين", fileName: "التقاء الساكنين", description: "قواعد التخلص من التقاء الساكنين في اللغة العربية، إما بالتحريك (بالكسر أو الفتح أو الضم) أو بالحذف."),
        Book(title: "لآلئ البيان", fileName: "لآلئ البيان", description: "منظومة لآلئ البيان في متشابهات القرآن الكريم، دليل رائع لحفاظ القرآن الكريم لتثبيت المتشابهات اللفظية."),
        Book(title: "الوقف على أواخر الكلم", fileName: "الوقف على أواخر الكلم", description: "أوجه الوقف الجائزة على الكلمات القرآنية: بالسكون المحض، أو الروم، أو الإشمام مع بيان الحالات."),
        Book(title: "المقطوع والموصول", fileName: "المقطوع والموصول", description: "معرفة المقطوع والموصول من الكلمات في الرسم العثماني وفائدة معرفته لحالات الوقف والابتداء الاضطراري."),
        Book(title: "هاء الكناية", fileName: "هاء الكناية", description: "أحكام هاء الضمير (هاء الكناية) من حيث الصلة الكبرى والصغرى، ومستثنيات رواية حفص في القراءة."),
        Book(title: "الابتداء", fileName: "الابتداء", description: "أحكام الابتداء الاختياري بالكلمات القرآنية وعلاقته بتمام المعنى وعدم تشويه دلالات الآيات."),
        Book(title: "المقدمة الجزرية", fileName: "المقدمة الجزرية", description: "متن المقدمة فيما على قارئ القرآن أن يعلمه للإمام ابن الجزري، الباب التأسيسي الأعظم لطلاب التجويد."),
        Book(title: "ضبط المصحف", fileName: "ضبط المصحف", description: "تاريخ نشأة علم الضبط الحركي والإعجام للمصحف، ورموز الضبط المستعملة في المصاحف المعاصرة."),
        Book(title: "نونية السخاوي", fileName: "نونية السخاوي", description: "منظومة الإمام السخاوي في أصول تجويد القراءة والتحذير من التكلف والتعسف في النطق بالكلمات."),
        Book(title: "التفخيم والترقيق", fileName: "التفخيم والترقيق", description: "تقسيم الحروف الهجائية من حيث التفخيم والترقيق: حروف مستعلية، حروف مستفلة، والحروف الدائرة بينهما."),
        Book(title: "ياءآت الإضافة والزوائد", fileName: "ياءات الإضافة والزوائد", description: "أحكام ياءات الإضافة الزائدة في الرسم القرآني والخلاف الوارد فيها بالفتح أو الإسكان عند حفص."),
        Book(title: "بيان المكي والمدني", fileName: "بيان المكي والمدني", description: "قواعد تصنيف السور المكية والمدنية، خصائص ومميزات كل قسم، وفوائد هذا العلم المفسرة للآيات."),
        Book(title: "تحفة الأطفال", fileName: "تحفة الأطفال", description: "منظومة تحفة الأطفال والغلمان في تجويد القرآن للشيخ سليمان الجمزوري، البوابة الأولى للمبتدئين."),
        Book(title: "الوقف على نعم وبلى وكلا", fileName: "الوقف على نعم وبلى وكلا", description: "دراسة دلالية حول جواز أو منع الوقف والابتداء بكلمات مخصوصة كالوقف على بلى، نعم، وكلا."),
        Book(title: "رسم المصحف", fileName: "رسم المصحف", description: "أصول وقواعد رسم المصحف العثماني الخمسة: الحذف، الزيادة، الهمز، البدل، والوصل والفصل.")
    ]

    var filteredBooks: [Book] {
        if searchText.isEmpty { return books }
        return books.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollViewReader { scrollProxy in
                ZStack {
                    // Main layer
                    Color(.systemGroupedBackground).ignoresSafeArea()

                    VStack(spacing: 0) {
                        CustomNavigationBar(showMenu: $showMenu, searchText: $searchText)

                        ScrollView {
                            Color.clear.frame(height: 0).id("top")
                            LazyVStack(spacing: 12) {
                                ForEach(filteredBooks) { book in
                                    BookCardView(book: book)
                                        .onTapGesture {
                                            navigationPath.append(AppRoute.book(book))
                                        }
                                }
                            }
                            .padding(.vertical, 16)
                        }
                    }

                    // FAB
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                withAnimation { scrollProxy.scrollTo("top", anchor: .top) }
                            } label: {
                                Image(systemName: "chevron.up")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color.brandTeal)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 3)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                        }
                    }

                    // Menu overlay
                    if showMenu {
                        ZStack {
                            Color.black.opacity(0.4)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut) { showMenu = false }
                                }

                            HStack {
                                SideMenuView(showMenu: $showMenu) { item in
                                    switch item {
                                    case "about":
                                        showMenu = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            navigationPath.append(AppRoute.about)
                                        }
                                    case "share":
                                        showShareSheet = true
                                    default:
                                        break
                                    }
                                }
                                .frame(width: 280)
                                .transition(.move(edge: .leading))
                                .environment(\.layoutDirection, .rightToLeft)
                                Spacer()
                            }
                            .ignoresSafeArea()
                        }
                        .zIndex(4)
                    }
                }
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(items: ["تطبيق دليل حفص لتعلم التجويد"])
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .about:
                        ReaderView(fileName: "عن التطبيق")
                            .ignoresSafeArea(edges: .bottom)
                    case .book(let book):
                        ReaderView(fileName: book.fileName)
                            .ignoresSafeArea(edges: .bottom)
                            .navigationTitle(book.title)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
    }
}

// Custom Navigation Bar
struct CustomNavigationBar: View {
    @Binding var showMenu: Bool
    @Binding var searchText: String
    @State private var isSearchActive = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            if isSearchActive {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 17, weight: .semibold))
                    
                    TextField("بحث في الكتب...", text: $searchText)
                        .focused($isFocused)
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .font(.custom("KFGQPCUthmanicScriptHAFS", size: 16))
                    
                    if !searchText.isEmpty {
                        Button {
                            withAnimation {
                                searchText = ""
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 20))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearchActive = false
                        searchText = ""
                        isFocused = false
                    }
                } label: {
                    Text("إلغاء")
                        .font(.custom("KFGQPCUthmanicScriptHAFS", size: 16))
                        .foregroundColor(.white)
                }
            } else {
                Button(action: { withAnimation { showMenu = true } }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                Spacer()

                Text("دليل (حفص)")
                    .font(.custom("KFGQPCUthmanicScriptHAFS", size: 20))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    withAnimation {
                        isSearchActive = true
                        isFocused = true
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 15)
        .background(Color.brandTeal)
    }
}

// Book Card View
struct BookCardView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(book.title)
                .font(.custom("KFGQPCUthmanicScriptHAFS", size: 22))
                .foregroundColor(.brandTeal)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer().frame(height: 8)

            Text(book.description)
                .font(.custom("GeezaPro", size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
                .lineSpacing(8)

            Spacer().frame(height: 12)

            HStack {
                Spacer()
                Text("انقر للمزيد ...")
                    .font(.custom("KFGQPCUthmanicScriptHAFS", size: 20))
                    .foregroundColor(.brandTeal)
            }

            Image("separator")
                .resizable()
                .frame(height: 32)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color.appBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

// Side Menu Drawer
struct SideMenuView: View {
    @Binding var showMenu: Bool
    var onItemSelected: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()
                Image("tinted")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.horizontal, 40)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .padding(.top, 40)
            .background(Color.brandTeal)

            ScrollView {
                VStack(spacing: 0) {
                    DrawerItem(icon: "book.closed.fill", title: "المكتبة القرءانية") {
                        onItemSelected("library")
                        showMenu = false
                    }
                    DrawerItem(icon: "clipboard", title: "نماذج اختبارات") { }
                    DrawerItem(icon: "gearshape", title: "الثيمات") { }
                    DrawerItem(icon: "info.circle.fill", title: "عن التطبيق") {
                        onItemSelected("about")
                        showMenu = false
                    }
                    DrawerItem(icon: "square.and.arrow.up.fill", title: "مشاركة التطبيق") {
                        onItemSelected("share")
                        showMenu = false
                    }
                    DrawerItem(icon: "envelope.fill", title: "تواصل معنا") { }
                    Divider()
                    DrawerItem(icon: "multiply.circle.fill", title: "خروج", isDestructive: true) {
                        showMenu = false
                    }
                }
                .padding(.vertical, 8)
            }
            .background(Color.appBackground)
        }
        .frame(width: 280)
        .ignoresSafeArea()
    }
}

// Drawer Item
struct DrawerItem: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.brandTeal)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.custom("KFGQPCUthmanicScriptHAFS", size: 17))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
