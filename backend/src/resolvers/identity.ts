import { IdentityResolvers } from "../gen/resolvers";
import { IdentityDb, AccountModel } from "../db";

export const Identity: IdentityResolvers = {
  owner: async (parent, args, context, info) => {
    const _owner = await AccountModel.findById((parent as IdentityDb)._owner);

    if (!_owner) {
      throw Error("Identidade sem dono");
    }

    return _owner;
  },
};
