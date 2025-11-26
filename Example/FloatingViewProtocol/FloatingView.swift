//
//  FloatingView.swift
//  FloatingViewProtocol_Example
//
//  Created by Duanhu on 2025/10/17.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import FloatingViewProtocol

class FloatingView: UIView, FloatingViewProtocol {
    // 遵守协议后，可以重写属性
    let component = FloatingViewProtocolComponent()
    
    // 自定义属性
    private var isPartiallyHiddenOnRight = false
    private let visibleWidthWhenHidden: CGFloat = 20
    
    
    private var needHidden = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        intialConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        intialConfigure()
    }
    
    private func intialConfigure() {
        backgroundColor = .red
        layer.cornerRadius = 12
        addFloatingPanGestureRecognizer()
  
        adsorbableEdges = [.right, .left]
        isAutoAdsorb = true
        floatingEdgeInsets = .init(top: 83, left: 16, bottom: 34, right: 16)
        
        // 设置代理来处理吸附后的部分隐藏逻辑
        floatingDelegate = self
    }
    
    // 自定义方法：处理在右侧部分隐藏
    private func hideOnRightSide() {
        guard let superview = superview, !isPartiallyHiddenOnRight else { return }
        // 计算目标位置：右侧对齐，只露出visibleWidthWhenHidden宽度
        let targetX = superview.bounds.width - visibleWidthWhenHidden
        
        UIView.animate(withDuration: 0.35) {
            self.frame.origin.x = targetX
        } completion: { _ in
            self.isPartiallyHiddenOnRight = true
            self.needHidden = false
        }
    }
    
    // 自定义方法：完全显示
    private func showFully() {
        guard let superview = superview, isPartiallyHiddenOnRight else { return }
        
        // 计算目标位置：完全显示在右侧
        let targetX = superview.bounds.width - self.frame.width - floatingEdgeInsets.right
        
        UIView.animate(withDuration: 0.35) {
            self.frame.origin.x = targetX
        } completion: { _ in
            self.isPartiallyHiddenOnRight = false
        }
    }
}

// MARK: - FloatingViewDelegate

extension FloatingView: FloatingViewDelegate {
    func floatingViewDidBeginDragging(panGestureRecognizer: UIPanGestureRecognizer) {
        // 开始拖动时，如果是部分隐藏状态，先完全显示
        if isPartiallyHiddenOnRight {
            showFully()
        }
    }
    
    func floatingViewDidMove(panGestureRecognizer: UIPanGestureRecognizer) {
        // 拖动结束后，如果吸附到了右侧，执行部分隐藏
        guard let superview = superview else { return }
        
        let maxX = superview.bounds.width - self.bounds.width / 2
        // 当拖到最右侧边缘，则需要吸附到右侧，执行部分隐藏
        needHidden = center.x >= maxX
    }
    
    func floatingViewDidEndDragging(panGestureRecognizer: UIPanGestureRecognizer) {
        guard needHidden else { return }
        hideOnRightSide()
    }
}
