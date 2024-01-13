/* --------------------------------------------------------------
 * :: :  M  E  T  A  V  E  R  S  E  :                          ::
 * --------------------------------------------------------------
 * This program is free software; you can redistribute it, and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Check out
 * the GNU General Public License for more details.
 *
 * You should have received a copy for this software license, the
 * GNU General Public License along with this program; or, if not
 * write to the Free Software Foundation, Inc., to the address of
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 *       Copyright (C) 2023 Wabi Foundation. All Rights Reserved.
 * --------------------------------------------------------------
 *  . x x x . o o o . x x x . : : : .    o  x  o    . : : : .
 * -------------------------------------------------------------- */

import Foundation
import Python
import PythonKit

public class PyBundle
{
  public static var shared = PyBundle()

  private init()
  {
    pyInit()
  }

  public var stdLibPath: String?
  public var libDynloadPath: String?

  public func pyInit()
  {
    #if os(macOS)
    let stdlib = "python/3.11/macOS/python-stdlib"
    #elseif os(visionOS)
    let stdlib = "python/3.11/xrOS/python-stdlib"
    #elseif os(iOS)
    let stdlib = "python/3.11/iOS/python-stdlib"
    #else
    let stdlib = "python/3.11/macOS/python-stdlib"
    #endif

    guard
      let stdLibPath = Bundle.module.path(forResource: stdlib, ofType: nil),
      let libDynloadPath = Bundle.module.path(forResource: "\(stdlib)/lib-dynload", ofType: nil)
    else { return }

    self.stdLibPath = stdLibPath
    self.libDynloadPath = libDynloadPath

    setenv("PYTHONHOME", stdLibPath, 1)
    setenv("PYTHONPATH", "\(stdLibPath):\(libDynloadPath)", 1)
    Py_Initialize()
  }

  public func pyInfo()
  {
    let sys = Python.import("sys")
    print("Python v\(sys.version_info.major).\(sys.version_info.minor)")
    print("Python Version: \(sys.version)")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")
  }
}
