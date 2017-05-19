//
//  SavoryViewSpec.swift
//  Savory
//
//  Created by Nandiin Borjigin on 20/05/2017.
//  Copyright © 2017 Nandiin Borjigin. All rights reserved.
//

import Quick
import Nimble
@testable import Savory

class DummyView: SavoryView {
    var indexPath: IndexPath!
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        self.indexPath = indexPath
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}

class SavoryViewSpec: QuickSpec {
    override func spec() {
        describe("SavoryView") {
            var view: SavoryView!
            
            beforeEach {
                view = SavoryView()
            }
            
            it("is a subclass of UITableView") {
                expect(view).to(beAKindOf(UITableView.self))
            }
            
            describe("rowHeight") {
                it("equals UITableViewAutomaticDimension") {
                    expect(view.rowHeight) == UITableViewAutomaticDimension
                }
                it("doesn't change even when assigned a different value") {
                    view.rowHeight = 100
                    expect(view.rowHeight) == UITableViewAutomaticDimension
                }
            }
            
            describe("estimatedRowHeight") {
                it("is greater than 0") {
                    expect(view.estimatedRowHeight) > 0
                }
                it("is writable") {
                    let old = view.estimatedRowHeight
                    view.estimatedRowHeight = old + 10
                    expect(view.estimatedRowHeight) == old + 10
                }
            }
            
            describe("dataSource") {
                it("is a instance of SavoryTableViewDataSource") {
                    expect(view.dataSource).to(beAnInstanceOf(SavoryTableViewDataSource.self))
                }
                it("is not writable") {
                    let old = view.dataSource
                    let new = SavoryTableViewDataSource()
                    expect(old) !== new
                    view.dataSource = new
                    expect(view.dataSource) !== new
                    expect(view.dataSource) === old
                }
            }
            
            describe("dequeue after an expanded panel and a collapsed panel") {
                var view: DummyView!
                beforeEach {
                    view = DummyView()
                    view.stateProvider = SimpleStateProvider([.expanded, .collapsed, .collapsed])
                    view.savoryDelegate = DummyDelegate()
                    view.headerIdentifier = "header"
                    view.register(UITableViewCell.self, forCellReuseIdentifier: "header")
                    view.bodyIdentifier = "body"
                    view.register(UITableViewCell.self, forCellReuseIdentifier: "body")
                    view.estimatedRowHeight = 100
                }
                context("header") {
                    var cell: SavoryHeaderCell!
                    beforeEach {
                        cell = view.dequeueReusableHeaderCell(forPanelAt: 2)
                    }
                    it("dequeues cell for 0 - 3") {
                        expect(view.indexPath) == IndexPath(row: 3, section: 0)
                    }
                    it("dequeus cell with headerIdentifier") {
                        expect(cell.reuseIdentifier) == "header"
                    }
                }
                context("body") {
                    var cell: SavoryHeaderCell!
                    beforeEach {
                        cell = view.dequeueReusableBodyCell(forPanelAt: 2)
                    }
                    it("dequeues cell for 0 - 4") {
                        expect(view.indexPath) == IndexPath(row: 4, section: 0)
                    }
                    it("dequeues cell with bodyIdentifier") {
                        expect(cell.reuseIdentifier) == "body"
                    }
                }
            }
        }
    }
}
