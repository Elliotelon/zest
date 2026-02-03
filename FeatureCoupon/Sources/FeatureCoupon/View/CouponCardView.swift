import SwiftUI

struct CouponCardView: View {
    let coupon: Coupon
    let hasIssued: Bool
    let isIssuing: Bool
    let onIssue: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            Divider()
            issuedStatus
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(coupon.isExhausted ? Color.gray.opacity(0.1) : Color.orange.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    coupon.isExhausted ? Color.gray.opacity(0.3) : Color.orange.opacity(0.3),
                    lineWidth: 1
                )
        )
    }
    
    @ViewBuilder
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "ticket.fill")
                        .foregroundColor(coupon.isExhausted ? .gray : .orange)
                    Text(coupon.name)
                        .font(.headline)
                        .foregroundColor(coupon.isExhausted ? .gray : .primary)
                }
                Text("\(Int(coupon.discountRate))% 할인")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(coupon.isExhausted ? .gray : .orange)
            }
            
            Spacer()
            
            issueButton
        }
    }
    
    @ViewBuilder
    private var issueButton: some View {
        if !hasIssued && !coupon.isExhausted {
            Button(action: onIssue) {
                if isIssuing {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                } else {
                    Text("발급받기")
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.orange)
            .cornerRadius(20)
            .disabled(isIssuing)
        } else if hasIssued {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("보유중")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.green)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.green.opacity(0.1))
            .cornerRadius(20)
        }
    }
    
    @ViewBuilder
    private var issuedStatus: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("발급 현황:")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if coupon.isExhausted {
                Text("소진됨")
                    .font(.caption)
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(4)
            } else {
                HStack(spacing: 4) {
                    Text("\(coupon.issuedCount)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(coupon.remainingCount < 10 ? .red : .orange)
                    Text("/ \(coupon.maxCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("(\(coupon.remainingCount)개 남음)")
                        .font(.caption2)
                        .foregroundColor(coupon.remainingCount < 10 ? .red : .secondary)
                }
            }
        }
    }
}


