#ifndef PHENIXAPP_H
#define PHENIXAPP_H

#include "MooseApp.h"

class phenixApp;

template <>
InputParameters validParams<phenixApp>();

class phenixApp : public MooseApp
{
public:
  phenixApp(InputParameters parameters);
  virtual ~phenixApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void registerObjectDepends(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void associateSyntaxDepends(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* PHENIXAPP_H */
