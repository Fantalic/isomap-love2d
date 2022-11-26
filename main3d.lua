local menori = require 'menori'
local application = menori.Application

local ml = menori.ml
local vec3 = ml.vec3
local quat = ml.quat

local NewScene = menori.Scene:extend('NewScene')

function NewScene:init()
	NewScene.super.init(self)

	local aspect = menori.Application.w/menori.Application.h
	self.camera = menori.PerspectiveCamera(60, aspect, 0.5, 1024)
	self.environment = menori.Environment(self.camera)

	local gltf = menori.glTFLoader.load('example_assets/players_room_model/', 'scene')
	local model_node_tree = menori.ModelNodeTree(gltf)

	self.root_node = menori.Node()
	self.root_node:attach(model_node_tree)

	self.y_angle = 0
end

function NewScene:render()
	love.graphics.clear(0.3, 0.25, 0.2)

	love.graphics.setDepthMode('less', true)
	self:render_nodes(self.root_node, self.environment)
	love.graphics.setDepthMode()
end

function NewScene:update_camera()
	self.y_angle = self.y_angle + 0.5
	local q = quat.from_euler_angles(0, math.rad(self.y_angle), math.rad(-45))
	local v = vec3(0, 0, 8)
	self.camera.eye = q * v
	self.camera:update_view_matrix()
end

function NewScene:update()
	self:update_camera()
	self:update_nodes(self.root_node, self.environment)
end

function love.load()
	local w, h = 960, 480
	application:resize_viewport(w, h)

	application:add_scene('new_scene', NewScene())
	application:set_scene('new_scene')
end

function love.draw()
	application:render()
end

function love.update(dt)
	application:update(dt)
end