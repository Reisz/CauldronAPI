CCoreApplication = class("CCoreApplication", QObject)
local _arguments, _instance
local _applicationName, _applicationVersion
local _organizationName, _organizationDomain
local _applicationFilePath, _applicationDirPath

function CCoreApplication:initialize(...)
    _arguments = {...}
    _instance = self
    _applicationFilePath = "/" .. shell.getRunningProgram()
	_applicationName = string.match(_applicationFilePath, "[^/]+$")
    if not _applicationName then _applicationName = _applicationFilePath end
    _applicationDirPath = string.sub(_applicationFilePath, 1, #_applicationFilePath - #_applicationName)
	_applicationVersion = "" _organizationName = "" _organizationDomain = ""
end

function CCoreApplication.static.applicationDirPath() return _applicationDirPath end

function CCoreApplication.static.applicationFilePath() return _applicationFilePath end

function CCoreApplication.static.applicationName() return _applicationName end

function CCoreApplication.static.applicationVersion() return _applicationVersion end

function CCoreApplication.static.arguments() return CStringList(unpack(_arguments)) end

function CCoreApplication.static.instance() return _instance end

function CCoreApplication.static.organizationDomain() return _organizationDomain end

function CCoreApplication.static.organizationName() return _organizationName end

function CCoreApplication.static.setApplicationName(name) _applicationName = name end

function CCoreApplication.static.setApplicationVersion(version) _applicationVersion = version end

function CCoreApplication.static.setOrganizationDomain(domain) _organizationDomain = domain end

function CCoreApplication.static.setOrganizationName(name) _organizationName = name end
