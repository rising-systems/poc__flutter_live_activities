import ActivityKit
import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      FootballMatchApp()
    }
  }
}

// We need to redefined live activities pipe
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState
  
  public struct ContentState: Codable, Hashable { }
  
  var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.dimitridessus.liveactivities")!

@available(iOSApplicationExtension 16.1, *)
struct FootballMatchApp: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      let matchName = sharedDefault.string(forKey: context.attributes.prefixedKey("name"))!
      
      let lat = sharedDefault.string(forKey: context.attributes.prefixedKey("lat"))!
      let lng = sharedDefault.string(forKey: context.attributes.prefixedKey("lng"))!

      let lastCheckTime = sharedDefault.string(forKey: context.attributes.prefixedKey("lastCheckTime"))!
      let lastUpdateDateTime = sharedDefault.string(forKey: context.attributes.prefixedKey("lastUpdateDateTime"))!

      let status = sharedDefault.string(forKey: context.attributes.prefixedKey("status"))!
      let message = sharedDefault.string(forKey: context.attributes.prefixedKey("message"))!

      let latestActivityId = sharedDefault.string(forKey: context.attributes.prefixedKey("latestActivityId"))!
      
      ZStack {
    LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottom)
    
    VStack {
        Text("ID: \(latestActivityId)")
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(.top, 8) 
        HStack {
            ZStack {
                VStack(alignment: .center, spacing: 2.0) {
                    Text("Latitude")
                        .lineLimit(1)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(lat)
                        .lineLimit(1)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 120, height: 80)
                .padding(.bottom, 8)
                .padding(.top, 8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            
            VStack(alignment: .center, spacing: 6.0) {
                VStack(alignment: .center, spacing: 1.0) {
                    Link(destination: URL(string: "la://my.app/stats")!) {
                        Text("Name:")
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                    
                    Text(matchName)
                        .font(.footnote)
                        .foregroundStyle(.white)
                    
                    Text("Status: \(status)")
                        .font(.footnote)
                        .foregroundStyle(.white)
                    
                    Text("Message: \(message)")
                        .font(.footnote)
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 6.0)
            
            ZStack {
                VStack(alignment: .center, spacing: 2.0) {
                    Text("Longitude")
                        .lineLimit(1)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(lng)
                        .lineLimit(1)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 120, height: 80)
                .padding(.bottom, 8)
                .padding(.top, 8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .padding(.horizontal, 2.0)
    }
}
.frame(height: 200)
    } dynamicIsland: { context in
      let matchName = sharedDefault.string(forKey: context.attributes.prefixedKey("name"))!
      
      let lat = sharedDefault.string(forKey: context.attributes.prefixedKey("lat"))!
      let lng = sharedDefault.string(forKey: context.attributes.prefixedKey("lng"))!

      let lastCheckTime = sharedDefault.string(forKey: context.attributes.prefixedKey("lastCheckTime"))!
      let lastUpdateDateTime = sharedDefault.string(forKey: context.attributes.prefixedKey("lastUpdateDateTime"))!

      let status = sharedDefault.string(forKey: context.attributes.prefixedKey("status"))!
      let message = sharedDefault.string(forKey: context.attributes.prefixedKey("message"))!
      
      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .center, spacing: 2.0) {
            Text("Latitude")
              .lineLimit(1)
              .font(.subheadline)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
            
            Text(lat)
              .lineLimit(1)
              .font(.footnote)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
          }
          .frame(width: 70, height: 120)
          .padding(.bottom, 8)
          .padding(.top, 8)
          
          
        }
        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .center, spacing: 2.0) {
            Text("Longitude")
              .lineLimit(1)
              .font(.subheadline)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
            
            Text(lng)
              .lineLimit(1)
              .font(.footnote)
              .fontWeight(.bold)
              .multilineTextAlignment(.center)
          }
          .frame(width: 70, height: 120)
          .padding(.bottom, 8)
          .padding(.top, 8)
          
          
        }
        DynamicIslandExpandedRegion(.center) {
          VStack(alignment: .center, spacing: 6.0) {
            VStack(alignment: .center, spacing: 1.0) {
              Link(destination: URL(string: "la://my.app/stats")!) {
                Text("Name:")
              }.padding(.vertical, 5).padding(.horizontal, 5)
              Text(matchName)
                .font(.footnote)
                .foregroundStyle(.white)
            }
            
          }
          .padding(.vertical, 6.0)
        }
      } compactLeading: {
        HStack {
         Text("\(lat)")
            .font(.title)
            .fontWeight(.bold)
        }
      } compactTrailing: {
        HStack {
          Text("\(lng)")
            .font(.title)
            .fontWeight(.bold)
        }
      } minimal: {
        ZStack {
        }
      }
    }
  }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}
