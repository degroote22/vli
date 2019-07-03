import { GraphQLResolveInfo } from "graphql";
export type Maybe<T> = T | null;
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
};

export type Account = {
  __typename?: "Account";
  _id: Scalars["String"];
  name: Scalars["String"];
  email: Scalars["String"];
  hash: Scalars["String"];
  items: Array<ItemForSale>;
  identities: Array<Identity>;
};

export type ContractInput = {
  sellingId: Scalars["String"];
  ammount: Scalars["Int"];
};

export type Identity = {
  __typename?: "Identity";
  _id: Scalars["String"];
  name: Scalars["String"];
  sellerName: Scalars["String"];
  active: Scalars["Boolean"];
  contracts: Array<SaleContract>;
  owner: Account;
};

export type ItemForSale = {
  __typename?: "ItemForSale";
  _id: Scalars["String"];
  name: Scalars["String"];
  price: Scalars["String"];
  history: Array<SaleHistory>;
  owner: Account;
  contracts: Array<SaleContract>;
};

export type Mutation = {
  __typename?: "Mutation";
  authenticateAccount?: Maybe<Scalars["String"]>;
  registerIdentity?: Maybe<Identity>;
  registerContractToIdentity?: Maybe<Identity>;
  registerItem?: Maybe<ItemForSale>;
  registerAccount?: Maybe<Account>;
  addSalePutHistory?: Maybe<SalePutHistory>;
  addSaleRemoveHistory?: Maybe<SaleRemoveHistory>;
};

export type MutationAuthenticateAccountArgs = {
  email: Scalars["String"];
  password: Scalars["String"];
};

export type MutationRegisterIdentityArgs = {
  input: RegisterIdentityInput;
};

export type MutationRegisterContractToIdentityArgs = {
  input: RegisterContractToIdentityInput;
};

export type MutationRegisterItemArgs = {
  input: RegisterItemInput;
};

export type MutationRegisterAccountArgs = {
  input: RegisterAccountInput;
};

export type MutationAddSalePutHistoryArgs = {
  input: SalePutHistoryInput;
};

export type MutationAddSaleRemoveHistoryArgs = {
  input: SaleRemoveHistoryInput;
};

export type Query = {
  __typename?: "Query";
  identityById?: Maybe<Identity>;
  accountById?: Maybe<Account>;
};

export type QueryIdentityByIdArgs = {
  id: Scalars["String"];
};

export type QueryAccountByIdArgs = {
  id: Scalars["String"];
};

export type RegisterAccountInput = {
  name: Scalars["String"];
  email: Scalars["String"];
  password: Scalars["String"];
};

export type RegisterContractToIdentityInput = {
  identityId: Scalars["String"];
  contract: ContractInput;
};

export type RegisterIdentityInput = {
  name: Scalars["String"];
  sellerName: Scalars["String"];
};

export type RegisterItemInput = {
  name: Scalars["String"];
  price: Scalars["String"];
};

export type SaleContract = {
  __typename?: "SaleContract";
  _id: Scalars["String"];
  seller: Identity;
  selling: ItemForSale;
  history: Array<SaleHistory>;
  ammount: Scalars["Int"];
};

export type SaleHistory = {
  _id: Scalars["String"];
  when: Scalars["String"];
  userGeneratedId: Scalars["String"];
};

export type SalePutHistory = SaleHistory & {
  __typename?: "SalePutHistory";
  _id: Scalars["String"];
  when: Scalars["String"];
  userGeneratedId: Scalars["String"];
  ammount: Scalars["Int"];
  longitude: Scalars["Float"];
  latitude: Scalars["Float"];
};

export type SalePutHistoryInput = {
  contractId: Scalars["String"];
  when: Scalars["String"];
  userGeneratedId: Scalars["String"];
  ammount: Scalars["Int"];
  longitude: Scalars["Float"];
  latitude: Scalars["Float"];
};

export type SaleRemoveHistory = SaleHistory & {
  __typename?: "SaleRemoveHistory";
  _id: Scalars["String"];
  when: Scalars["String"];
  userGeneratedId: Scalars["String"];
  removedId: Scalars["String"];
};

export type SaleRemoveHistoryInput = {
  contractId: Scalars["String"];
  when: Scalars["String"];
  userGeneratedId: Scalars["String"];
  removedId: Scalars["String"];
};

export type Subscription = {
  __typename?: "Subscription";
  salesInItem: SaleHistory;
};

export type SubscriptionSalesInItemArgs = {
  itemId: Scalars["String"];
};

export type ResolverTypeWrapper<T> = Promise<T> | T;

export type ResolverFn<TResult, TParent, TContext, TArgs> = (
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => Promise<TResult> | TResult;

export type StitchingResolver<TResult, TParent, TContext, TArgs> = {
  fragment: string;
  resolve: ResolverFn<TResult, TParent, TContext, TArgs>;
};

export type Resolver<TResult, TParent = {}, TContext = {}, TArgs = {}> =
  | ResolverFn<TResult, TParent, TContext, TArgs>
  | StitchingResolver<TResult, TParent, TContext, TArgs>;

export type SubscriptionSubscribeFn<TResult, TParent, TContext, TArgs> = (
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => AsyncIterator<TResult> | Promise<AsyncIterator<TResult>>;

export type SubscriptionResolveFn<TResult, TParent, TContext, TArgs> = (
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => TResult | Promise<TResult>;

export interface SubscriptionResolverObject<TResult, TParent, TContext, TArgs> {
  subscribe: SubscriptionSubscribeFn<TResult, TParent, TContext, TArgs>;
  resolve?: SubscriptionResolveFn<TResult, TParent, TContext, TArgs>;
}

export type SubscriptionResolver<
  TResult,
  TParent = {},
  TContext = {},
  TArgs = {}
> =
  | ((
      ...args: any[]
    ) => SubscriptionResolverObject<TResult, TParent, TContext, TArgs>)
  | SubscriptionResolverObject<TResult, TParent, TContext, TArgs>;

export type TypeResolveFn<TTypes, TParent = {}, TContext = {}> = (
  parent: TParent,
  context: TContext,
  info: GraphQLResolveInfo
) => Maybe<TTypes>;

export type NextResolverFn<T> = () => Promise<T>;

export type DirectiveResolverFn<
  TResult = {},
  TParent = {},
  TContext = {},
  TArgs = {}
> = (
  next: NextResolverFn<TResult>,
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => TResult | Promise<TResult>;

/** Mapping between all available schema types and the resolvers types */
export type ResolversTypes = {
  Query: ResolverTypeWrapper<{}>;
  String: ResolverTypeWrapper<Scalars["String"]>;
  Identity: ResolverTypeWrapper<Identity>;
  Boolean: ResolverTypeWrapper<Scalars["Boolean"]>;
  SaleContract: ResolverTypeWrapper<SaleContract>;
  ItemForSale: ResolverTypeWrapper<ItemForSale>;
  SaleHistory: ResolverTypeWrapper<SaleHistory>;
  Account: ResolverTypeWrapper<Account>;
  Int: ResolverTypeWrapper<Scalars["Int"]>;
  Mutation: ResolverTypeWrapper<{}>;
  RegisterIdentityInput: RegisterIdentityInput;
  RegisterContractToIdentityInput: RegisterContractToIdentityInput;
  ContractInput: ContractInput;
  RegisterItemInput: RegisterItemInput;
  RegisterAccountInput: RegisterAccountInput;
  SalePutHistoryInput: SalePutHistoryInput;
  Float: ResolverTypeWrapper<Scalars["Float"]>;
  SalePutHistory: ResolverTypeWrapper<SalePutHistory>;
  SaleRemoveHistoryInput: SaleRemoveHistoryInput;
  SaleRemoveHistory: ResolverTypeWrapper<SaleRemoveHistory>;
  Subscription: ResolverTypeWrapper<{}>;
};

/** Mapping between all available schema types and the resolvers parents */
export type ResolversParentTypes = {
  Query: {};
  String: Scalars["String"];
  Identity: Identity;
  Boolean: Scalars["Boolean"];
  SaleContract: SaleContract;
  ItemForSale: ItemForSale;
  SaleHistory: SaleHistory;
  Account: Account;
  Int: Scalars["Int"];
  Mutation: {};
  RegisterIdentityInput: RegisterIdentityInput;
  RegisterContractToIdentityInput: RegisterContractToIdentityInput;
  ContractInput: ContractInput;
  RegisterItemInput: RegisterItemInput;
  RegisterAccountInput: RegisterAccountInput;
  SalePutHistoryInput: SalePutHistoryInput;
  Float: Scalars["Float"];
  SalePutHistory: SalePutHistory;
  SaleRemoveHistoryInput: SaleRemoveHistoryInput;
  SaleRemoveHistory: SaleRemoveHistory;
  Subscription: {};
};

export type AccountResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["Account"]
> = {
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  name?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  email?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  hash?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  items?: Resolver<
    Array<ResolversTypes["ItemForSale"]>,
    ParentType,
    ContextType
  >;
  identities?: Resolver<
    Array<ResolversTypes["Identity"]>,
    ParentType,
    ContextType
  >;
};

export type IdentityResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["Identity"]
> = {
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  name?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  sellerName?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  active?: Resolver<ResolversTypes["Boolean"], ParentType, ContextType>;
  contracts?: Resolver<
    Array<ResolversTypes["SaleContract"]>,
    ParentType,
    ContextType
  >;
  owner?: Resolver<ResolversTypes["Account"], ParentType, ContextType>;
};

export type ItemForSaleResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["ItemForSale"]
> = {
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  name?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  price?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  history?: Resolver<
    Array<ResolversTypes["SaleHistory"]>,
    ParentType,
    ContextType
  >;
  owner?: Resolver<ResolversTypes["Account"], ParentType, ContextType>;
  contracts?: Resolver<
    Array<ResolversTypes["SaleContract"]>,
    ParentType,
    ContextType
  >;
};

export type MutationResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["Mutation"]
> = {
  authenticateAccount?: Resolver<
    Maybe<ResolversTypes["String"]>,
    ParentType,
    ContextType,
    MutationAuthenticateAccountArgs
  >;
  registerIdentity?: Resolver<
    Maybe<ResolversTypes["Identity"]>,
    ParentType,
    ContextType,
    MutationRegisterIdentityArgs
  >;
  registerContractToIdentity?: Resolver<
    Maybe<ResolversTypes["Identity"]>,
    ParentType,
    ContextType,
    MutationRegisterContractToIdentityArgs
  >;
  registerItem?: Resolver<
    Maybe<ResolversTypes["ItemForSale"]>,
    ParentType,
    ContextType,
    MutationRegisterItemArgs
  >;
  registerAccount?: Resolver<
    Maybe<ResolversTypes["Account"]>,
    ParentType,
    ContextType,
    MutationRegisterAccountArgs
  >;
  addSalePutHistory?: Resolver<
    Maybe<ResolversTypes["SalePutHistory"]>,
    ParentType,
    ContextType,
    MutationAddSalePutHistoryArgs
  >;
  addSaleRemoveHistory?: Resolver<
    Maybe<ResolversTypes["SaleRemoveHistory"]>,
    ParentType,
    ContextType,
    MutationAddSaleRemoveHistoryArgs
  >;
};

export type QueryResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["Query"]
> = {
  identityById?: Resolver<
    Maybe<ResolversTypes["Identity"]>,
    ParentType,
    ContextType,
    QueryIdentityByIdArgs
  >;
  accountById?: Resolver<
    Maybe<ResolversTypes["Account"]>,
    ParentType,
    ContextType,
    QueryAccountByIdArgs
  >;
};

export type SaleContractResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["SaleContract"]
> = {
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  seller?: Resolver<ResolversTypes["Identity"], ParentType, ContextType>;
  selling?: Resolver<ResolversTypes["ItemForSale"], ParentType, ContextType>;
  history?: Resolver<
    Array<ResolversTypes["SaleHistory"]>,
    ParentType,
    ContextType
  >;
  ammount?: Resolver<ResolversTypes["Int"], ParentType, ContextType>;
};

export type SaleHistoryResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["SaleHistory"]
> = {
  __resolveType: TypeResolveFn<
    "SalePutHistory" | "SaleRemoveHistory",
    ParentType,
    ContextType
  >;
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  when?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  userGeneratedId?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
};

export type SalePutHistoryResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["SalePutHistory"]
> = {
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  when?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  userGeneratedId?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  ammount?: Resolver<ResolversTypes["Int"], ParentType, ContextType>;
  longitude?: Resolver<ResolversTypes["Float"], ParentType, ContextType>;
  latitude?: Resolver<ResolversTypes["Float"], ParentType, ContextType>;
};

export type SaleRemoveHistoryResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["SaleRemoveHistory"]
> = {
  _id?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  when?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  userGeneratedId?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
  removedId?: Resolver<ResolversTypes["String"], ParentType, ContextType>;
};

export type SubscriptionResolvers<
  ContextType = any,
  ParentType = ResolversParentTypes["Subscription"]
> = {
  salesInItem?: SubscriptionResolver<
    ResolversTypes["SaleHistory"],
    ParentType,
    ContextType,
    SubscriptionSalesInItemArgs
  >;
};

export type Resolvers<ContextType = any> = {
  Account?: AccountResolvers<ContextType>;
  Identity?: IdentityResolvers<ContextType>;
  ItemForSale?: ItemForSaleResolvers<ContextType>;
  Mutation?: MutationResolvers<ContextType>;
  Query?: QueryResolvers<ContextType>;
  SaleContract?: SaleContractResolvers<ContextType>;
  SaleHistory?: SaleHistoryResolvers;
  SalePutHistory?: SalePutHistoryResolvers<ContextType>;
  SaleRemoveHistory?: SaleRemoveHistoryResolvers<ContextType>;
  Subscription?: SubscriptionResolvers<ContextType>;
};

/**
 * @deprecated
 * Use "Resolvers" root object instead. If you wish to get "IResolvers", add "typesPrefix: I" to your config.
 */
export type IResolvers<ContextType = any> = Resolvers<ContextType>;
