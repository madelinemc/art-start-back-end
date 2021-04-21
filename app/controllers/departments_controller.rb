class DepartmentsController < ApplicationController

    def index
        departments = Department.first(16)
        render({json: departments, except: [:created_at, :updated_at] })
    end

end
