//
//  Cells.swift
//  SpreadsheetView
//
//  Created by Kishikawa Katsumi on 5/8/17.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import SpreadsheetView

class DateCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class DayTitleCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TimeTitleCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TimeCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right

        contentView.addSubview(label)
    }

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 6, dy: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ScheduleCell: Cell {
    let label = UILabel()
    var color: UIColor = .clear {
        didSet {
            backgroundView?.backgroundColor = color
        }
    }

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 0)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ETResultCell: Cell {
    let label = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    
    var color: UIColor = .clear {
        didSet {
            backgroundView?.backgroundColor = color
        }
    }

    override var frame: CGRect {
        didSet {
//            label.frame = bounds.insetBy(dx: 4, dy: 0)
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()
        label.frame = CGRect(x: 0, y: 0, width: 164, height: 31)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        contentView.addSubview(label)
        
        label2.frame = CGRect(x: 0, y: 31, width: 82, height: 31)
        label2.font = UIFont.systemFont(ofSize: 15)
        label2.textAlignment = .center
        contentView.addSubview(label2)
        
        label3.frame = CGRect(x: 82, y: 31, width: 82, height: 31)
        label3.font = UIFont.systemFont(ofSize: 15)
        label3.textAlignment = .center
        contentView.addSubview(label3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ETSecResultCell: Cell {
    let label = UILabel()
    let label2 = UILabel()
    
    var color: UIColor = .clear {
        didSet {
            backgroundView?.backgroundColor = color
        }
    }

    override var frame: CGRect {
        didSet {
//            label.frame = bounds.insetBy(dx: 4, dy: 0)
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()
        label.frame = CGRect(x: 0, y: 0, width: 82, height: 31)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        contentView.addSubview(label)
        
        label2.frame = CGRect(x: 0, y: 31, width: 82, height: 31)
        label2.font = UIFont.systemFont(ofSize: 15)
        label2.textAlignment = .center
        contentView.addSubview(label2)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
