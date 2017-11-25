#include "phenixApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

// Materials

template <>
InputParameters
validParams<phenixApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

phenixApp::phenixApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  phenixApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  phenixApp::associateSyntax(_syntax, _action_factory);
}

phenixApp::~phenixApp() {}

void
phenixApp::registerApps()
{
  registerApp(phenixApp);
}

void
phenixApp::registerObjects(Factory & factory)
{
  /* Uncomment Factory parameter and register your new production objects here! */
}

void
phenixApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new production objects here! */
}

void
phenixApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
phenixApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
phenixApp__registerApps()
{
  phenixApp::registerApps();
}

extern "C" void
phenixApp__registerObjects(Factory & factory)
{
  phenixApp::registerObjects(factory);
}

extern "C" void
phenixApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  phenixApp::associateSyntax(syntax, action_factory);
}
