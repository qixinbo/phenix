#include "phenixTestApp.h"
#include "phenixApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<phenixTestApp>()
{
  InputParameters params = validParams<phenixApp>();
  return params;
}

phenixTestApp::phenixTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  phenixApp::registerObjectDepends(_factory);
  phenixApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  phenixApp::associateSyntaxDepends(_syntax, _action_factory);
  phenixApp::associateSyntax(_syntax, _action_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    phenixTestApp::registerObjects(_factory);
    phenixTestApp::associateSyntax(_syntax, _action_factory);
  }
}

phenixTestApp::~phenixTestApp() {}

void
phenixTestApp::registerApps()
{
  registerApp(phenixApp);
  registerApp(phenixTestApp);
}

void
phenixTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
phenixTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
phenixTestApp__registerApps()
{
  phenixTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
phenixTestApp__registerObjects(Factory & factory)
{
  phenixTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
phenixTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  phenixTestApp::associateSyntax(syntax, action_factory);
}
