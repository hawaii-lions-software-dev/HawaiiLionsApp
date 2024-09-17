import SwiftUI
import PDFKit

struct ConstitutionBylawsView: View {
    
    // You need to add sample pdf in the app bundle.
    // Just drag and drop a pdf fine in the project.
    let url = Bundle.main.url(forResource: "District-50-Constitution-By-Laws-04_27_2024", withExtension: "pdf")!
    
    var body: some View {
        
        PDFKitView(pdfData: PDFDocument(url: url)!)
        
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let pdfData: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = self.pdfData
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update pdf view if needed
    }
}

#Preview {
    ContentView()
}
