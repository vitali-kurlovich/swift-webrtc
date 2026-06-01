//
//  Created by Kurlovich Vitali on 5/31/26.
//

import SwiftUI

extension HorizontalAlignment {
    private enum ColumnID: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.leading]
        }
    }

    static let column = HorizontalAlignment(ColumnID.self)
}

struct TwoColumnRow<Primary: View, Second: View>: View {
    @ViewBuilder let primary: () -> Primary
    @ViewBuilder let second: () -> Second

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            primary()
            second()
                .alignmentGuide(.column) { dims in
                    dims[.leading]
                }
        }
    }
}

struct TwoColumn<Content: View>: View {
    let spacing: CGFloat?
    @ViewBuilder let content: () -> Content

    init(spacing: CGFloat? = nil,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        VStack(alignment: .column, spacing: spacing) {
            content()
        }
    }
}

#Preview {
    TwoColumn(spacing: 8) {
        TwoColumnRow {
            Text("Name")
        } second: {
            Text("value")
        }

        TwoColumnRow {
            Text("Name")
        } second: {
            Text("dddd dd  d dvalue")
        }

        TwoColumnRow {
            Text("Name 444444")
        } second: {
            Text("In SwiftUI, you can create a multiline text by simply using the Text view. By default, if the text content is too long for a single line, it will wrap onto multiple lines. However, you can control the number of lines and other properties of the text. Here's how to create multiline text")
        }
    }
}
