class CodeTemplater
  def initialize(options = {})
    @options = options
  end

  def get_binding
    binding()
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
<% if @options[:generate_presenter_delegate] %>
protocol #{name}PresenterDelegate : class {

}
<% end %>}
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
    <%if @options[:generate_presenter_delegate]%>private weak var delegate: #{name}PresenterDelegate?<% end %>

    init(viewContract: #{name}ViewContract<%if @options[:generate_presenter_delegate]%>, delegate: #{name}PresenterDelegate<% end %>) {
        self.viewContract = viewContract
        <%if @options[:generate_presenter_delegate]%>self.delegate = delegate<% end %>
    }

    //MARK: - #{name}Presenter

    func start() {

    }
}
}
  end

  def dependency_provider_content(name, options = @options)
    if options[:generate_presenter_delegate]
      %{func #{name.camelize(:lower)}Presenter(viewContract: #{name}ViewContract, presenterDelegate: #{name}PresenterDelegate) -> #{name}Presenter? {
    return presenterAssembler
        .resolver
        .resolve(#{name}Presenter.self, arguments: viewContract, presenterDelegate)
}
}
    else
      %{func #{name.camelize(:lower)}Presenter(viewContract: #{name}ViewContract) -> #{name}Presenter? {
    return presenterAssembler
        .resolver
        .resolve(#{name}Presenter.self, argument: viewContract)
}
}
    end
  end

  def presenter_assembly_content(name, options = @options)
    if options[:generate_presenter_delegate]
      %{container.register(#{name}Presenter.self) { r, viewContract, delegate in
    #{name}PresenterImplementation(
        viewContract: viewContract,
        delegate: delegate
    )
}
}
    else
      %{container.register(#{name}Presenter.self) { r, viewContract in
    #{name}PresenterImplementation(
        viewContract: viewContract
    )
}
}
    end
  end
end
