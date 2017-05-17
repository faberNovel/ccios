class CodeTemplater
  def initialize(options = {})
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

class #{name}ViewController : SharedViewController, #{name}ViewContract {
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

    private weak var viewContract: #{name}ViewContract?

    init(viewContract: #{name}ViewContract) {
        self.viewContract = viewContract
    }

    //MARK: - #{name}Presenter

    func start() {

    }
}
}
  end

  def dependency_provider_content(name, options = @options)
    %{func #{name.camelize(:lower)}Presenter(viewContract: #{name}ViewContract) -> #{name}Presenter? {
    return presenterAssembler
        .resolver
        .resolve(#{name}Presenter.self, argument: viewContract)
}
}
  end

  def presenter_assembly_content(name, options = @options)
    %{container.register(#{name}Presenter.self) { r, viewContract in
    #{name}PresenterImplementation(
        viewContract: viewContract
    )
}
}
  end
end
