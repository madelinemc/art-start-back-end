class DepartmentsController < ApplicationController

    def index
        departments = Department.all
        render({json: departments, except: [:created_at, :updated_at] })
    end

end
