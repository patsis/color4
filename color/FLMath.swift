//
//  FLMath.swift
//  Color 4
// SOme math made for color 4
//
//  Created by Harry Patsis on 11/12/2016.
//  Copyright © 2016 Harry Patsis. All rights reserved.
//

import UIKit

public class FLPoint {
  var x: Float
  var y: Float

  public init(x: Float, y: Float) {
    self.x = x
    self.y = y
  }

  public var length: Float {
    return sqrt(x * x + y * y)
  }

  public var length2: Float {
    return x * x + y * y
  }

  static public func == (left: FLPoint, right: FLPoint) -> Bool {
    return left.x == right.x && left.y == right.y
  }

//  static public func ^ (left: FLPoint, right: FLPoint) -> Float {
//    return (left.x * right.x + left.y * right.y) / (left.length * right.length)
//  }

  static public func + (left: FLPoint, right: FLPoint) -> FLPoint {
    return FLPoint(x: left.x + right.x, y: left.y + right.y)
  }

  static public func - (left: FLPoint, right: FLPoint) -> FLPoint {
    return FLPoint(x: left.x - right.x, y: left.y - right.y)
  }

  static public func * (left: FLPoint, right: Float) -> FLPoint {
    return FLPoint(x: left.x * right, y: left.y * right)
  }

  static public func * (left: Float, right: FLPoint) -> FLPoint {
    return FLPoint(x: left * right.x, y: left * right.y)
  }

  static public func / (left: FLPoint, right: Float) -> FLPoint {
    return FLPoint(x: left.x / right, y: left.y / right)
  }

  public func distanceToSegment(_ p1: FLPoint, _ p2: FLPoint) -> Float {
    let a = p2.y - p1.y
    let fa = abs(a)
    let b = p1.x - p2.x
    let fb = abs(b)
    if fa < 1e-4 && fb < 1e-4 {
      return (self - p1).length
    }

    let c = -p1.y * b - p1.x * a
    let a2 = a * a
    let b2 = b * b
    var xa: Float, ya: Float, l: Float
    if fa >= 1e-4 {
      ya = (-a * b * self.x - b * c + a2 * self.y) / (a2 + b2);
      xa = (-c - b * ya) / a;
    } else {
      xa = (-a * b * self.y - a * c + b2 * self.x) / (a2 + b2);
      ya = (-c - a * xa) / b;
    }

    if fb >= 1e-4 {
      l = (xa - p1.x) / (p2.x - p1.x);
    } else {
      l = (ya - p1.y) / (p2.y - p1.y);
    }

    if l < 0.0 {
      return (p1 - self).length
    } else if l > 1.0 {
      return (p2 - self).length
    }
    return (FLPoint(x: xa, y: ya) - self).length;
  }


}

public class FLBezier {
  var pt1, pt2, pt3, pt4: FLPoint
  var length: Float

  public init(shape: [Float], index: Int) {
    pt1 = FLPoint(x: shape[index + 0], y: shape[index + 1])
    pt2 = FLPoint(x: shape[index + 2], y: shape[index + 3])
    pt3 = FLPoint(x: shape[index + 4], y: shape[index + 5])
    pt4 = FLPoint(x: shape[index + 6], y: shape[index + 7])
    length = FLBezier.bezierLength(pt1, pt2, pt3, pt4)
  }

  static fileprivate func bezierPt(_ v1:FLPoint, _ v2:FLPoint, _ v3:FLPoint, _ v4:FLPoint, u:Float) -> FLPoint {
    let u1 = 1 - u
    let a = u1 * u1 * u1
    let b = 3.0 * u * u1 * u1
    let c = 3.0 * u * u * u1
    let d = u * u * u
    return FLPoint(x: v1.x * a + v2.x * b + v3.x * c + v4.x * d,
                   y: v1.y * a + v2.y * b + v3.y * c + v4.y * d);
  }

  static fileprivate func bezierLength(_ v1:FLPoint, _ v2:FLPoint, _ v3:FLPoint, _ v4:FLPoint) -> Float {
    var d:Float = 0.0
    let step:Float = 0.05
    var u = step;
    var vb = v1, va = vb;
    while (u < 1.0) {
      va = vb;
      vb = bezierPt(v1, v2, v3, v4, u: u);
      d = d + (vb - va).length
      u = u + step;
    }
    d = d + (v4-vb).length
    return d;
  }


  func pointAt(_ u:Float) -> FLPoint{
    return FLBezier.bezierPt(pt1, pt2, pt3, pt4, u: u)
  }

  fileprivate func difAt(_ u:Float) -> FLPoint {
    let u2 = u * u;
    let u1 = (1 - u) * (1 - u)

    let va = pt1 * (-3.0 * u1)
    let vb = pt2 * (3.0 * u1 + 6.0 * u2 - 6.0 * u)
    let vc = pt3 * (6.0 * u - 9.0 * u2)
    let vd = pt4 * 3.0 * u2
    return va + vb + vc + vd;
  }

  func lengthAtU(_ u:Float) -> Float{
    if (u <= 0) {
      return 0
    }
    if (u >= 1) {
      return length
    }

    let m = pointAt(u);
    let d = difAt(u)
    return FLBezier.bezierLength(pt1, pt1 + (pt2 - pt1) * u, m - d / 3.0 * u, m);
  }

  fileprivate func nextPt(_ dist:Float, error:Float) -> FLPoint {
    if dist == 0 {
      return pt1
    }
     var u:Float = 0.5, ua:Float = 0, ub:Float = 1
     while true {
      let d = lengthAtU(u)

      if (abs(dist - d) < error) {
        return pointAt(u)
      }
      if (d < dist) {
        ua = u
      } else {
        ub = u
       }
      u = (ua + ub) / 2
     }
  }

  public func pointsOfDistance(_ dist: Float, ignoreLast: Bool) -> [FLPoint] {
    var pts: [FLPoint] = [pt1]
    let newDist: Float = length / (round(length / dist))
    var count = Int(round(length / newDist))
    if ignoreLast {
      count -= 1
    }

    if (count > 0) {
      var pr = pt1
      for i in 1...count {
        let pt = nextPt(Float(i) * newDist, error: 1.0)
        if pt.x != pr.x || pt.y != pr.y {
          pts.append(pt)
          pr = pt
        }
      }
    }
    return pts
  }
}

public class FLShape {
  var id: Int
  var points: [FLPoint]
  var area: Float = 0
  var left: Float = 1e8
  var right: Float = -1e8
  var top: Float = -1e8
  var bottom: Float = 1e8

  public init(id: Int, shape: [Float], step: Float) {
    self.id = id
    self.points = []
    let count = shape.count - 2
    /// debug check for open
    if shape[0] != shape[count] || shape[1] != shape[count + 1] {
      print("*** shape \(id) is OPEN")
    }
    /// end debug
    var i = 0
    while i < count {
      let bez = FLBezier(shape: shape, index: i)
      /// start debug
      if bez.pt1 == bez.pt4 {
        print("*** shape \(id) has ZERO BEZIER: \(Int(bez.pt1.x)),\(Int(bez.pt1.y)),\(Int(bez.pt2.x)),\(Int(bez.pt2.y)),\(Int(bez.pt3.x)),\(Int(bez.pt3.y)),")
      }
      ///end debug
      self.points.append(contentsOf: bez.pointsOfDistance(step, ignoreLast: true))
      i += 6
    }
    self.points.append(FLPoint(x: shape[count], y: shape[count + 1]))
    calcRect()

    self.area = -calcArea()
    if self.area < 0 { /// check clockwise
      self.points.reverse()
//      print("shape with id: \(id) is reversed")
//      let cnt = shape.count
//      for i in stride(from: cnt - 2, through: 0, by: -2) {
//        if i > 0 {
//          print("\(Int(shape[i])),\(Int(shape[i + 1]))", terminator: ",")
//        } else {
//          print("\(Int(shape[i])),\(Int(shape[i + 1]))")
//        }
//      }
//      print("\n")
//      print("...")
    }
  }

  private func calcRect() {
    for p in points {
      if p.x < left {
        left = p.x
      }
      if p.x > right {
        right = p.x
      }
      if p.y < bottom {
        bottom = p.y
      }
      if p.y > top {
        top = p.y
      }
    }
  }

  private func calcArea() -> Float {
    var area:Float = 0
    var v1 = points[0]
    for i in 1..<points.count {
      let v2 = points[i]
      area = area + (v1.x * v2.y) - (v2.x * v1.y);
      v1 = v2
    }
    return area
  }

  private func overlaps(_ shape: FLShape) -> Bool {
    return (shape.left <= right) && (left <= shape.right) && (bottom <= shape.top) && (shape.bottom <= top)
  }

  private func containsPointInRect(_ pt: FLPoint) -> Bool {
    return (left <= pt.x) && (right >= pt.x) && (bottom <= pt.y) && (top >= pt.y)
  }


  private func ChkInt(_ p1: FLPoint, _ p2: FLPoint, _ p3: FLPoint, _ p4: FLPoint) -> Bool {
    let dx21 = p2.x - p1.x;
    let dy21 = p2.y - p1.y;

    if (abs(dx21) < 1e-8 && abs(dy21) < 1e-8) {
      return false;
    }

    let dx43 = p4.x - p3.x;
    let dy43 = p4.y - p3.y;

    let sm = (dx21 * dy43 - dy21 * dx43);
    if (abs(sm) < 1e-8) {
      return false;
    }

    let m = (dy21 * (p3.x - p1.x) - dx21 * (p3.y - p1.y)) / sm;
    if (m < 0 || m > 1.0) {
      return false;
    }

    let l = (abs(dy21) < 1e-8) ? (p3.x - p1.x + dx43 * m) / dx21 : (p3.y - p1.y + dy43 * m) / dy21;
    if (l < 0 || l > 1.0) {
      return false;
    }

    return true;
  }


  private func containsPoint(_ pt: FLPoint) -> Bool {
    var result = false;
    var p = points[0]
    for i in 1..<points.count {
      let v = points[i]
      if (v.y > pt.y) != ( p.y > pt.y) &&
          (pt.x < (p.x - v.x) * (pt.y - v.y) / (p.y - v.y) + v.x) {
        result = !result;
      }
      p = v
    }
    return result
  }

  public func touchesWith(_ shape: FLShape) -> Bool {
    if overlaps(shape) {
//      var touches = 0
      var a1 = points[0]

//      for i in 1..<points.count {
//        let a2 = points[i]
//        let m = (a2 + a1) / 2
//        var p1 = m - a1
//        p1 = 2 * (p1 / p1.length)
//        p1 = FLPoint(x: p1.y, y: -p1.x)
//        let p2 = m - p1
//        p1 = m + p1
//        if shape.containsPointInRect(p1) || shape.containsPointInRect(p2) {
//          var b1 = shape.points[0]
//          for j in 1..<shape.points.count {
//            let b2 = shape.points[j]
//            if ChkInt(p1, p2, b1, b2) {
// //              touches += 1
// //              if touches > 0 {
//                return true
// //              }
//            }
//            b1 = b2
//          }
//        }
//        a1 = a2
//      }

      for i in 1..<points.count {
        let a2 = points[i]
        let m = (a2 + a1) / 2
        var p1 = m - a1
        p1 = 2 * (p1 / p1.length)
        p1 = FLPoint(x: -p1.y, y: p1.x)
        p1 = m + p1
        if (shape.containsPointInRect(p1) && shape.containsPoint(p1)) {
          return true
        }
        a1 = a2
      }

    }
    return false
  }

}

