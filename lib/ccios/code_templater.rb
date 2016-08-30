class CodeTemplater
  def initialize(options)
    @options = options
  end

  def content_for_suffix(prefix, suffix)
    method_name = suffix.underscore + '_content'
    public_send(method_name, prefix) if respond_to? method_name
  end

  def view_contract_content(name, options = @options)
    %{//
//  #{name}ViewContract.swift
//  #{options[:project_name]}
//
//  Created by #{options[:full_username]} on #{options[:date]}.
//
//

import Foundation

protocol #{name}ViewContract : class {

}
}
  end

  def view_controller_content(name, options = @options)
    %{//
//  #{name}ViewController.swift
//  #{options[:project_name]}
//
//  Created by #{options[:full_username]} on #{options[:date]}.
//
//

import Foundation
import UIKit

class #{name}ViewController : SharedViewController, #{name}ViewContract, PresenterInjectable {
    var presenter: #{name}Presenter?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.start()
    }

    //MARK: - #{name}ViewContract

}
}
  end

  def presenter_content(name, options = @options)
    %{//
//  #{name}Presenter.swift
//  #{options[:project_name]}
//
//  Created by #{options[:full_username]} on #{options[:date]}.
//
//

import Foundation

protocol #{name}Presenter {
    func start()
}
}
  end


  def presenter_implementation_content(name, options = @options)
    %{//
//  #{name}PresenterImplementation.swift
//  #{options[:project_name]}
//
//  Created by #{options[:full_username]} on #{options[:date]}.
//
//

import Foundation

class #{name}PresenterImplementation : #{name}Presenter {

    private let viewContract: #{name}ViewContract

    init(viewContract: #{name}ViewContract) {
        self.viewContract = viewContract
    }

    //MARK: - #{name}Presenter

    func start() {

    }
}
}
  end

  def component_content(name, options = @options)
    %{//
//  #{name}Component.swift
//  #{options[:project_name]}
//
//  Created by #{options[:full_username]} on #{options[:date]}.
//
//

import Foundation
import Cleanse

struct #{name}Component : Component {
    typealias Root = PropertyInjector<#{name}ViewController>

    let applicationModule: ApplicationModule
    let #{name.camelize(:lower)}ViewContract: #{name}ViewContract

    //MARK: - Component

    func configure<B : Binder>(binder binder: B) {
        binder.install(module: applicationModule)
        binder.install(module: PresenterInjector<#{name}ViewController>())
        binder
            .bind(#{name}Presenter.self)
            .to(factory: #{name}PresenterImplementation.init)
        binder
            .bind(#{name}ViewContract.self)
            .to(value: #{name.camelize(:lower)}ViewContract)
    }
}
}
  end
end
