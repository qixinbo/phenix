#ifndef PHENIXTESTAPP_H
#define PHENIXTESTAPP_H

#include "MooseApp.h"

class phenixTestApp;

template <>
InputParameters validParams<phenixTestApp>();

class phenixTestApp : public MooseApp
{
public:
  phenixTestApp(InputParameters parameters);
  virtual ~phenixTestApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* PHENIXTESTAPP_H */
